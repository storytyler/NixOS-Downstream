{ pkgs, lib, ... }:
let
  # Audio libraries needed for voicemode - matching official flake
  # See: https://github.com/mbailey/voicemode/blob/master/flake.nix
  audioLibs = [
    pkgs.portaudio
    pkgs.libpulseaudio
    pkgs.alsa-lib
  ];

  # Wrapper script matching upstream flake.nix exactly
  # Upstream uses writeShellScriptBin with PKG_CONFIG_PATH, CPATH, LIBRARY_PATH
  # which are required for simpleaudio to compile during uvx invocation
  voice-mode = pkgs.writeShellScriptBin "voice-mode" ''
    export LD_LIBRARY_PATH="${
      lib.makeLibraryPath (audioLibs ++ [ pkgs.stdenv.cc.cc.lib ])
    }''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

    export PKG_CONFIG_PATH="${
      lib.makeSearchPathOutput "dev" "lib/pkgconfig" audioLibs
    }''${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"

    export CPATH="${lib.makeSearchPathOutput "dev" "include" audioLibs}''${CPATH:+:$CPATH}"

    export LIBRARY_PATH="${lib.makeLibraryPath audioLibs}''${LIBRARY_PATH:+:$LIBRARY_PATH}"

    export PATH="${
      lib.makeBinPath [
        pkgs.gcc
        pkgs.pkg-config
        pkgs.ffmpeg
        pkgs.pulseaudio
        pkgs.alsa-utils
      ]
    }''${PATH:+:$PATH}"

    exec ${pkgs.uv}/bin/uvx voice-mode "$@"
  '';
in
{
  environment.systemPackages = [ voice-mode ];

  # Create voicemode config via home-manager
  home-manager.sharedModules = [
    (_: {
      home.file.".voicemode/voicemode.env".text = ''
        # Voice Mode Configuration
        # Caddy proxy at :6721 routes to Kokoro TTS (:8880) and Whisper STT (:9000)

        # TTS endpoints (used by converse and MCP tools)
        export VOICEMODE_TTS_BASE_URLS="http://localhost:6721/v1"

        # STT endpoints (used by MCP tools)
        export VOICEMODE_STT_BASE_URLS="http://localhost:6721/v1"

        # OpenAI base URL (used by CLI transcribe command)
        export OPENAI_BASE_URL="http://localhost:6721/v1"

        # Dummy API key (local services don't require a real key)
        export OPENAI_API_KEY="sk-dummy"

        # Whisper model for STT (hwdsl2/whisper-server:cuda with large-v3-turbo)
        export VOICEMODE_WHISPER_MODEL="whisper-1"

        # Preferred voices (af_sky = Kokoro, alloy = fallback)
        export VOICEMODE_VOICES="af_sky,alloy"

        # Prefer local providers
        export VOICEMODE_PREFER_LOCAL="true"

        # Audio feedback enabled
        export VOICEMODE_AUDIO_FEEDBACK="true"
      '';
    })
  ];
}
