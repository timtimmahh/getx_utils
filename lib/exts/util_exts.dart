import 'package:get/get.dart';

extension RxBoolExtensions on RxBool {
  Rx<bool> setTrue() {
    value = true;
    return this;
  }

  Rx<bool> setFalse() {
    value = false;
    return this;
  }
}

const ROUTE_FORGOT_PASSWORD = '/forgot-password';
const ROUTE_RESET_PASSWORD = '/resetPassword';
const ROUTE_AUTH = '/auth';
const ROUTE_ACCOUNT = '/account';
const ROUTE_SPLASH = '/splash';
const ROUTE_HOME = '/';
const ROUTE_SETTINGS = '/settings';
const ROUTE_ANALYSIS = '/analysis';
