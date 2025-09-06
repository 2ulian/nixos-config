{ config, pkgs, ... }:
{
  services.ollama = {
    enable = true;
    acceleration = "cuda";

    # Optional: preload models, see https://ollama.com/library
    loadModels = [ "gpt-oss:latest" ];
  };
}
