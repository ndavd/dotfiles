{
  pkgs,
  inputs,
  system,
  ...
}:
{
  environment = {
    systemPackages = [ inputs.self.packages.${system}.nvim ];
    sessionVariables = {
      MANPAGER = "nvim +Man!";
      MANWIDTH = 100;
      EDITOR = "nvim";
      VISUAL = "nvim";
      QML_IMPORT_PATH = "${pkgs.quickshell}/lib/qt-6/qml:${pkgs.qt6.qtdeclarative}/lib/qt-6/qml";
    };
  };
}
