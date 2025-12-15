// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  // Auth Routes
  static const LOGIN = '/login';
  static const SIGN_UP = '/sign-up';

  // Main Routes
  static const HOME = '/home';
  static const PROFILE = '/profile';
  static const EDIT_PROFILE = '/edit-profile';

  // Vendor Routes
  static const VENDOR_LIST = '/vendors';
  static const VENDOR_DETAIL = '/vendor/detail';
  static const VENDOR_ADD = '/vendor/add';
  static const VENDOR_EDIT = '/vendor/edit';
}