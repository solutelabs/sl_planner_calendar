import 'dart:developer';

///log the given data
void appLog(dynamic data, {bool show = false}) {
  if (show) {
    log(data.toString());
  }
}
