import 'package:app/pages/book/book_info_page.dart';
import 'package:app/pages/book/book_pay_page.dart';
import 'package:app/pages/book/book_result_page.dart';
import 'package:app/pages/invoice/create_invoice_page.dart';
import 'package:app/pages/invoice/edit_invoice_page.dart';
import 'package:app/pages/invoice/invoice_list_page.dart';
import 'package:app/pages/invoice/issue_invoice_page.dart';
import 'package:app/pages/login/bind_page.dart';
import 'package:app/pages/login/login_page.dart';
import 'package:app/pages/login/register_page.dart';
import 'package:app/pages/me/setting.dart';
import 'package:app/pages/pay_bill/pay_bill_page.dart';
import 'package:app/pages/pay_bill/pay_bill_result_page.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/pages_index.dart';
import 'package:app/pages/business/business_detail_page.dart';
import 'package:app/pages/invoice/invoice_detail_page.dart';

/*
 * 配置路由
 **/
class Page {
  static const String SPLASH_PAGE = '/splash';
  static const String ROOT_PAGE = '/rootPage';
  static const String LOGIN_PAGE = '/login';
  static const String BIND_PAGE = '/bind';
  static const String REGISTER_PAGE = '/register';
  static const String SETTING_PAGE = '/setting';
  static const String SEARCH_PAGE = '/searchPage';
  static const String ISSUE_PAGE = '/issueInvoicePage';
  static const String BUSINESS_DETAIL_PAGE = '/bussiness/detail';
  static const String SEARCH_RESULT_PAGE = '/searchResultPage';
  static const String INVOICE_LIST_PAGE = '/invoiceListPage';
  static const String INVOICE_DETAIL_PAGE = '/invoiceDetailPage';
  static const String INVOICE_EDIT_PAGE = '/invoiceEditPage';
  static const String INVOICE_CREATE_PAGE = '/invoiceCreatePage';
  static const String BOOK_RESULT_PAGE = '/bookResultPage';
  static const String BOOK_PAY_PAGE = '/bookPayPage';
  static const String BOOK_INFO_PAGE = '/bookInfoPage';
  static const String PAY_BILL_RESULT_PAGE = '/payBillResultPage';
  static const String PAY_BILL_PAGE = '/payBillPage';

  static Map<String, WidgetBuilder> getRoutes() {
    var route = {
      SPLASH_PAGE: (context) => SplashPage(),
      ROOT_PAGE: (context) => TabNavigator(),
      LOGIN_PAGE: (context) => LoginPage(),
      BIND_PAGE: (context) => BindPage(),
      REGISTER_PAGE: (context) => RegisterPage(),
      SETTING_PAGE: (context) => SettingPage(),
      SEARCH_PAGE: (context) => SearchPage(),
      ISSUE_PAGE: (context) => IssueInvoicePage(),
      BUSINESS_DETAIL_PAGE: (context) => BusinessDetailPage(0),
      SEARCH_RESULT_PAGE: (context) => SearchResultPage(),
      INVOICE_LIST_PAGE: (context) => InvoiceListPage(),
      INVOICE_DETAIL_PAGE: (context) => InvoiceDetailPage(),
      INVOICE_EDIT_PAGE: (context) => InvoiceEditPage(),
      INVOICE_CREATE_PAGE: (context) => InvoiceCreatePage(),
      BOOK_PAY_PAGE: (context) => BookPayPage(),
      BOOK_RESULT_PAGE: (context) => BookResultPage(),
      BOOK_INFO_PAGE: (context) => BookInfoPage(),
      PAY_BILL_RESULT_PAGE: (context) => PayBillResultPage(),
      PAY_BILL_PAGE: (context) => PayBillPage(),
    };

    return route;
  }
}
