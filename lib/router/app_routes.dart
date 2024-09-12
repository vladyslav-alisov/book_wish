enum AppRoutes {
  init("/", "/"),
  initError("/init_error", "/init_error"),
  home("/home", "/home"),
  details("details", "/home/details"),
  settings("/settings", "/settings");

  const AppRoutes(this.name, this.path);

  final String name;
  final String path;
}
