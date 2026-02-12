-- ABOUTME: Cucumber/Gherkin LSP configuration
-- ABOUTME: Configured for .feature files with C# step definitions

return {
    settings = {
        features = { "**/*.feature" },
        glue = { "**/Steps/*.steps.cs", "**/Steps/*.step.cs" },
    },
}
