{ pkgs, lib, ... }:
let
  # Audio libraries needed for voicemode - matching official flake
  # Uses libpulseaudio which works with PipeWire's pulse compatibility
  audioLibs = [
    pkgs.portaudio
    pkgs.libpulseaudio
    pkgs.alsa-lib
    pkgs.stdenv.cc.cc.lib
  ];

  # Create a wrapper for voice-mode matching the official flake approach
  # See: https://github.com/mbailey/voicemode/blob/master/flake.nix
  voice-mode-wrapper =
    pkgs.runCommand "voice-mode-wrapper"
      {
        buildInputs = [ pkgs.makeWrapper ];
      }
      ''
        mkdir -p $out/bin

        # Create the main voice-mode wrapper using uvx (matching official flake)
        makeWrapper ${pkgs.uv}/bin/uvx $out/bin/voice-mode \
          --set LD_LIBRARY_PATH "${lib.makeLibraryPath audioLibs}" \
          --prefix PATH : "${
            lib.makeBinPath [
              pkgs.python3
              pkgs.ffmpeg
              pkgs.gcc
              pkgs.pkg-config
              pkgs.pulseaudio # For paplay fallback
              pkgs.alsa-utils # For aplay/aplay fallback
            ]
          }" \
          --add-flags "voice-mode"

        # Also create a converse shortcut
        makeWrapper ${pkgs.uv}/bin/uvx $out/bin/voice-mode-converse \
          --set LD_LIBRARY_PATH "${lib.makeLibraryPath audioLibs}" \
          --prefix PATH : "${
            lib.makeBinPath [
              pkgs.python3
              pkgs.ffmpeg
              pkgs.gcc
              pkgs.pkg-config
              pkgs.pulseaudio
              pkgs.alsa-utils
            ]
          }" \
          --add-flags "voice-mode" \
          --add-flags "converse"
      '';
in
{
  # Install voice-mode wrapper system-wide
  environment.systemPackages = [
    voice-mode-wrapper
  ];

  # Create voicemode config via home-manager
  # Note: OPENAI_BASE_URL is used by CLI transcribe command
  # VOICEMODE_STT_BASE_URLS is used by the MCP tools
  home-manager.sharedModules = [
    (_: {
      home.file.".voicemode/voicemode.env".text = ''
        # Voice Mode Configuration
        # Using speaches (OpenAI-compatible) for both TTS and STT on port 8001

        # TTS endpoints (used by converse and MCP tools)
        export VOICEMODE_TTS_BASE_URLS="http://localhost:8001/v1"

        # STT endpoints (used by MCP tools)
        export VOICEMODE_STT_BASE_URLS="http://localhost:8001/v1"

        # OpenAI base URL (used by CLI transcribe command)
        export OPENAI_BASE_URL="http://localhost:8001/v1"

        # Dummy API key (speaches doesn't require real key)
        export OPENAI_API_KEY="sk-dummy"

        # Whisper model for STT
        export VOICEMODE_WHISPER_MODEL="Systran/faster-whisper-large-v3"

        # Preferred voices
        export VOICEMODE_VOICES="af_sky,alloy"

        # Prefer local providers
        export VOICEMODE_PREFER_LOCAL="true"

        # Audio feedback enabled
        export VOICEMODE_AUDIO_FEEDBACK="true"
      '';
    })
  ];
}
