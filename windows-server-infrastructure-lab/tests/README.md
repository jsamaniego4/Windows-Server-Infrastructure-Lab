# Static validation

The [Windows CI workflow](../../.github/workflows/powershell.yml) parses all six provisioning scripts in Windows PowerShell 5.1 and runs four selected PSScriptAnalyzer correctness rules. It never installs server roles or changes a domain. The first workflow run is pending.

Run the same check locally on Windows:

```powershell
Install-Module PSScriptAnalyzer -RequiredVersion 1.24.0 -Scope CurrentUser -Repository PSGallery
.\tests\Test-StaticValidation.ps1
```

The selected rules detect plaintext password handling, plaintext conversion to secure strings, missing ShouldProcess support in state-changing functions, and Invoke-Expression usage. Other analyzer rules are outside this gate.

Static analysis does not establish that Active Directory, DNS, DHCP, or GPO work. Complete [live validation](../docs/validation.md) on an isolated Windows lab. PowerShell is unavailable in the current macOS editing environment, so parsing and analyzer execution have not been performed here.
