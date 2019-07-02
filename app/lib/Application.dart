import 'package:event_bus/event_bus.dart';

class Application {
  static EventBus _eventBus;

  static EventBus getEventBus() {
    if (_eventBus == null) {
      _eventBus = new EventBus();
    }
    return _eventBus;
  }
}