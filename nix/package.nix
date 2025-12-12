{ rustPlatform, openssl, pkg-config, lib, config, ... }:
  rustPlatform.buildRustPackage {
    pname = "railboard-api";
    version = (builtins.fromTOML (builtins.readFile ../railboard-api/Cargo.toml)).package.version;
    src = ../.;
    cargoLock.lockFile = ../Cargo.lock;
    meta = with lib; {
      description = "API for german public transport data and backend for github.com/louboecker/railboard";
      homepage = "https://github.com/louboecker/railboard-api";
      license = licenses.gpl3;
    };
    
    doCheck = false;

    buildInputs = [
      openssl
    ];
    nativeBuildInputs = [
      pkg-config
    ];
  }