{
  description = "AI for recurrent thinking and dreaming";

  inputs = {
    nixpkgs.url = "github:DerDennisOP/nixpkgs/comp";

    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; config = { allowUnfree = true; }; };
        py = pkgs.python3.override {
          packageOverrides = python-final: python-prev: {
            torch = python-final.torch-bin // { inherit (python-prev.torch) cudaSupport cudaPackages; };
          };
        };
        pythonEnv = py.withPackages (ps: with ps; [
          huggingface-hub
          jupyter
          openai
          tqdm
          termcolor
	  torch
	  torchinfo
	  matplotlib
          numpy
	  gym
        ]);
        ignoreCollisions = true;
      in
      {
        nixpkgs.config = {
          allowUnfree = true;
          #cudaSupport = true;
        };
        devShell = with pkgs; mkShell {
          buildInputs = [
            stdenv.cc.cc.lib
            pam
          ];

          packages = [
            pythonEnv
            zip
            mindustry
            SDL2
            jdk11
            jre8
            gradle
          ];

          TRANSFORMERS_CACHE="./.cache";
          #LD_LIBRARY_PATH="${pkgs.linuxPackages.nvidia_x11}/lib";
          #CUDA_PATH="${pkgs.cudatoolkit}";
          #LD_LIBRARY_PATH=${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.ncurses5}/lib
          #EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
          EXTRA_CCFLAGS="-I/usr/include";
          OPENAI_API_KEY="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";
        };
      }
    );
}
