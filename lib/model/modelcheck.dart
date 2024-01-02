class AppSettings {
  final String appVersion;
  // final String showFunctionIOS;
  // final String idnewsOpenWebview;
  // final String openNewsInWebview;
  // final String isLogoNewYear;
  // final String isOpenAdmobInApp;
  // final String showDailyNewspaper;

  AppSettings({
    required this.appVersion,
    // required this.showFunctionIOS,
    // required this.idnewsOpenWebview,
    // required this.openNewsInWebview,
    // required this.isLogoNewYear,
    // required this.isOpenAdmobInApp,
    // required this.showDailyNewspaper,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      appVersion: json['app_version'],
      // showFunctionIOS: json['show_function_ios'],
      // idnewsOpenWebview: json['idnews_open_webview'],
      // openNewsInWebview: json['open_news_in_webview'],
      // isLogoNewYear: json['is_logo_new_year'],
      // isOpenAdmobInApp: json['is_open_admob_in_app'],
      // showDailyNewspaper: json['show_daily_newspaper'],
    );
  }
}
