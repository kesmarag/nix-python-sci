{
  description = "Kesmarag's scientific Python environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      myPythonEnv = pkgs.python3.withPackages (ps: with ps; [
        pytorch
        numpy
        # pandas
        matplotlib
        scikit-learn
        # jupyterlab
        # pip
      ]);

      tex = pkgs.texlive.combined.scheme-small

    in
    {
      # This defines the development shell
      devShells.${system}.default = pkgs.mkShell {
        # The packages that will be available in the shell's PATH.
        buildInputs = [
          myPythonEnv
          tex
          pkgs.texlivePackages.dvipng
          pkgs.ghostscript
          # Add any other system-level dependencies here if needed.
          # pkgs.cudatoolkit
        ];
        shellHook = ''
          echo "Welcome to Kesmarag's scientific Python environment!"
          echo ""
          python --version
        '';
      };
    };
}