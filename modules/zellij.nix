{
  inputs,
  system,
  ...
}:
{
  environment.systemPackages = [ inputs.self.packages.${system}.zellij ];
}
