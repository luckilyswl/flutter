library pin_input_text_field;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum PinEntryType {boxLoose}

/// Default text style of displaying pin
const TextStyle _kDefaultStyle = TextStyle(
  /// Default text color.
  color: Colors.white,

  /// Default text size.
  fontSize: 24.0,
);

abstract class PinDecoration {
  /// The style of painting text.
  final TextStyle textStyle;

  final ObscureStyle obscureStyle;

  PinEntryType get pinEntryType;

  const PinDecoration({
    this.textStyle,
    this.obscureStyle,
  });
}

/// The object determine the obscure display
class ObscureStyle {
  /// The wrap line string.
  static final _wrapLine = '\n';

  /// Determine whether replace [obscureText] with number.
  final bool isTextObscure;

  /// The display text when [isTextObscure] is true, default is '*'
  /// Do Not pass multiline string, it's not a good idea.
  final String obscureText;

  ObscureStyle({
    this.isTextObscure: false,
    this.obscureText: '*',
  }) : assert(obscureText.length > 0 &&
            obscureText.indexOf(_wrapLine) ==
                -1); // Not allowed empty string and multiline string.
}

/// The object determine the box stroke etc.
class BoxLooseDecoration extends PinDecoration {
  /// The box border radius.
  final Radius radius;

  /// The box border width.
  final double strokeWidth;

  /// The adjacent box gap.
  final double gapSpace;

  /// The box border color.
  final Color strokeColor;

  /// The box inside solid color, sometimes it equals to the box background.
  final Color solidColor;

  /// The border changed color when user enter pin.
  final Color enteredColor;

  const BoxLooseDecoration({
    TextStyle textStyle,
    ObscureStyle obscureStyle,
    this.enteredColor,
    this.solidColor,
    this.radius: const Radius.circular(8.0),
    this.strokeWidth: 1.0,
    this.gapSpace: 16.0,
    this.strokeColor: Colors.cyan,
  }) : super(
          textStyle: textStyle,
          obscureStyle: obscureStyle,
        );

  @override
  PinEntryType get pinEntryType => PinEntryType.boxLoose;
}

/// Helper class to handle inner or outside controller.
class PinEditingController extends TextEditingController {
  /// Control the maxLength of pin.
  int pinMaxLength;

  /// If the value set to true, the controller will dispose when the widget dispose.
  final bool autoDispose;

  PinEditingController({
    String text,
    this.autoDispose = true,
    @required int pinLength,
  })  : this.pinMaxLength = pinLength,
        super(text: text);

  @override
  set text(String newText) {
    /// Cut the parameter string if the length is longer than [_pinMaxLength].
    if (newText != null &&
        pinMaxLength != null &&
        newText.length > pinMaxLength) {
      newText = newText.substring(0, pinMaxLength);
    }
    super.text = newText;
  }
}

class PinInputTextField extends StatefulWidget {
  /// The max length of pin.
  final int pinLength;

  final ValueChanged<String> onChanged;

  /// The callback will execute when user click done.
  final ValueChanged<String> onSubmit;

  /// Decorate the pin.
  final PinDecoration decoration;

  /// Just like [TextField]'s inputFormatter.
  final List<TextInputFormatter> inputFormatters;

  /// Just like [TextField]'s keyboardType.
  final TextInputType keyboardType;

  /// Controls the pin being edited.
  /// If null, this widget will create its own [PinEditingController].
  final PinEditingController pinEditingController;

  /// Same as [TextField]'s autoFocus.
  final bool autoFocus;

  /// Same as [TextField]'s focusNode.
  final FocusNode focusNode;

  /// Same as [TextField]'s textInputAction.
  final TextInputAction textInputAction;

  ///Just like [TextField]'s enabled.
  final bool enabled;

  PinInputTextField({
    this.pinLength: 6,
    this.onSubmit,
    this.onChanged,
    this.decoration: const BoxLooseDecoration(),
    List<TextInputFormatter> inputFormatter,
    this.keyboardType: TextInputType.phone,
    PinEditingController pinEditingController,
    this.focusNode,
    this.autoFocus = false,
    this.textInputAction = TextInputAction.done,
    this.enabled = true,
  })  :

        ///pinLength must larger than 0.
        ///If pinEditingController isn't null, guarantee the [pinLength] equals to the pinEditingController's _pinMaxLength
        assert(pinLength != null &&
            pinLength > 0 &&
            ((pinEditingController != null &&
                    pinEditingController.pinMaxLength == pinLength) ||
                pinEditingController == null)),
        inputFormatters = inputFormatter ??
            <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
        this.pinEditingController =
            pinEditingController ?? PinEditingController(pinLength: pinLength);

  @override
  State createState() {
    return _PinInputTextFieldState();
  }
}

class _PinInputTextFieldState extends State<PinInputTextField> {
  /// The display text to the user.
  String _text;

  @override
  void initState() {
    widget.pinEditingController.addListener(() {
      setState(() {
        _text = widget.pinEditingController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    /// Only execute when the controller is autoDispose.
    if (widget.pinEditingController.autoDispose) {
      widget.pinEditingController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      /// The foreground paint to display pin.
      foregroundPainter: _PinPaint(
        text: _text,
        pinLength: widget.pinLength,
        decoration: widget.decoration,
      ),
      child: TextField(
        /// Actual textEditingController.
        controller: widget.pinEditingController,

        /// Fake the text style.
        style: TextStyle(
          /// Hide the editing text.
          color: Colors.transparent,
        ),

        /// Hide the Cursor.
        cursorColor: Colors.transparent,

        /// Hide the cursor.
        cursorWidth: 0.0,

        /// No need to correct the user input.
        autocorrect: false,

        /// Center the input to make more natrual.
        textAlign: TextAlign.center,

        /// Disable the actual textField selection.
        enableInteractiveSelection: false,

        /// The maxLength of the pin input, the default value is 6.
        maxLength: widget.pinLength,

        /// If use system keyboard and user click done, it will execute callback
        /// Note!!! Custom keyboard in Android will not execute, see the related issue [https://github.com/flutter/flutter/issues/19027]
        onSubmitted: widget.onSubmit,

        /// Default text input type is number.
        keyboardType: widget.keyboardType,

        /// only accept digits.
        inputFormatters: widget.inputFormatters,

        /// Defines the keyboard focus for this widget.
        focusNode: widget.focusNode,

        /// {@macro flutter.widgets.editableText.autofocus}
        autofocus: widget.autoFocus,

        /// The type of action button to use for the keyboard.
        ///
        /// Defaults to [TextInputAction.done]
        textInputAction: widget.textInputAction,

        /// {@macro flutter.widgets.editableText.obscureText}
        /// Default value of the obscureText is false. Make
        obscureText: true,

        /// Clear default text decoration.
        decoration: InputDecoration(
          /// Hide the counterText
          counterText: '',

          /// Hide the outline border.
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        enabled: widget.enabled,
        onChanged: widget.onChanged,
      ),
    );
  }
}

class _PinPaint extends CustomPainter {
  String text;
  final int pinLength;
  final double space;
  final PinEntryType type;
  final PinDecoration decoration;

  _PinPaint({
    @required String text,
    @required this.pinLength,
    this.decoration,
    this.space: 4.0,
    this.type: PinEntryType.boxLoose,
  }) {
    text ??= "";
    this.text = text.trim();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>
      !(oldDelegate is _PinPaint && oldDelegate.text == this.text);

  

  _drawBoxLoose(Canvas canvas, Size size) {
    /// Force convert to [BoxLooseDecoration].
    var dr = decoration as BoxLooseDecoration;
    Paint borderPaint = Paint()
      ..color = dr.strokeColor
      ..strokeWidth = dr.strokeWidth
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    /// Assign paint if [solidColor] is not null
    Paint insidePaint;
    if (dr.solidColor != null) {
      insidePaint = Paint()
        ..color = dr.solidColor
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
    }

    /// Calculate the width of each underline.
    double singleWidth = (size.width -
            dr.strokeWidth * 2 * pinLength -
            ((pinLength - 1) * dr.gapSpace)) /
        pinLength;

    var startX = dr.strokeWidth / 2;
    var startY = size.height - dr.strokeWidth / 2;

    /// Draw the each rect of pin.
    for (int i = 0; i < pinLength; i++) {
      if (i < text.length && dr.enteredColor != null) {
        borderPaint.color = dr.enteredColor;
      } else {
        borderPaint.color = dr.strokeColor;
      }
      RRect rRect = RRect.fromRectAndRadius(
          Rect.fromLTRB(
            startX,
            dr.strokeWidth / 2,
            startX + singleWidth + dr.strokeWidth,
            startY,
          ),
          dr.radius);
      canvas.drawRRect(rRect, borderPaint);
      if (insidePaint != null) {
        canvas.drawRRect(rRect, insidePaint);
      }
      startX += singleWidth + dr.gapSpace + dr.strokeWidth * 2;
    }

    /// The char index of the [text]
    var index = 0;
    startY = 0.0;

    /// Determine whether display obscureText.
    bool obscureOn;
    obscureOn = decoration.obscureStyle != null &&
        decoration.obscureStyle.isTextObscure;

    /// The text style of pin.
    TextStyle textStyle;
    if (decoration.textStyle == null) {
      textStyle = _kDefaultStyle;
    } else {
      textStyle = decoration.textStyle;
    }

    text.runes.forEach((rune) {
      String code;
      if (obscureOn) {
        code = decoration.obscureStyle.obscureText;
      } else {
        code = String.fromCharCode(rune);
      }
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          style: textStyle,
          text: code,
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      /// Layout the text.
      textPainter.layout();

      /// No need to compute again
      if (startY == 0.0) {
        startY = size.height / 2 - textPainter.height / 2;
      }
      startX = singleWidth * index +
          singleWidth / 2 -
          textPainter.width / 2 +
          dr.gapSpace * index +
          dr.strokeWidth * index * 2 +
          dr.strokeWidth;
      textPainter.paint(canvas, Offset(startX, startY));
      index++;
    });
  }

  

  @override
  void paint(Canvas canvas, Size size) {
    switch (decoration.pinEntryType) {
      case PinEntryType.boxLoose:
        {
          _drawBoxLoose(canvas, size);
          break;
        }
      default:
        break;
    }
  }
}