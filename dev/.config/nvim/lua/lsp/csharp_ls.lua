-- ABOUTME: C# LSP configuration with custom root pattern
-- ABOUTME: Prioritizes .sln files, falls back to .csproj/.fsproj/.git

return {
    root_markers = { "*.sln", "*.csproj", "*.fsproj", ".git" },
}
