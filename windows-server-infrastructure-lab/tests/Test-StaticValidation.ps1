#Requires -Version 5.1
[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
Import-Module PSScriptAnalyzer -RequiredVersion 1.24.0
$scriptPath = Join-Path (Split-Path $PSScriptRoot -Parent) 'scripts'
$files = @(Get-ChildItem -LiteralPath $scriptPath -Filter '*.ps1')
if ($files.Count -eq 0) { throw 'No lab scripts found.' }
foreach ($file in $files) {
    $tokens = $null
    $parseErrors = $null
    $null = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$parseErrors)
    if ($parseErrors.Count -gt 0) { throw ($parseErrors | Out-String) }
}
# These correctness rules are a focused gate, not a claim of full style compliance.
$rules = @('PSAvoidUsingPlainTextForPassword', 'PSAvoidUsingConvertToSecureStringWithPlainText', 'PSUseShouldProcessForStateChangingFunctions', 'PSAvoidUsingInvokeExpression')
$issues = @(Invoke-ScriptAnalyzer -Path $scriptPath -Recurse -IncludeRule $rules)
if ($issues.Count -gt 0) { throw ($issues | Format-Table -AutoSize | Out-String) }
Write-Output "Parsed $($files.Count) scripts; four selected analyzer rules passed."
