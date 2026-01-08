# NixAI Module

NixAI is a console-based application for diagnosing and configuring NixOS using AI models.

## Usage

Add to your configuration.nix:

```nix
{
  programs.nixai = {
    enable = true;
    
    # Optional: Enable MCP server for AI integration
    mcp = {
      enable = true;
      aiProvider = "ollama";
      aiModel = "llama3";
    };
  };
}
```

## Options

- `programs.nixai.enable` - Enable nixai package
- `programs.nixai.mcp.enable` - Enable MCP server service
- `programs.nixai.mcp.aiProvider` - AI provider (ollama, claude, groq, gemini, openai, llamacpp, custom)
- `programs.nixai.mcp.aiModel` - AI model to use
- `programs.nixai.mcp.socketPath` - MCP server socket path
- `programs.nixai.mcp.port` - MCP server port

## Integration

This module uses the nix-ai-help input from your main flake and provides both the CLI tool and optional MCP server service.