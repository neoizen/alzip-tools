# install.ps1 — alzip-compress 스킬을 개인 스코프(~/.claude/skills)에 설치한다.
# 사용:  powershell -ExecutionPolicy Bypass -File .\install.ps1
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$src  = Join-Path $root 'skills\alzip-compress'
$destRoot = Join-Path $env:USERPROFILE '.claude\skills'

if (-not (Test-Path -LiteralPath $src)) { Write-Error "스킬 소스를 찾을 수 없음: $src"; exit 1 }
New-Item -ItemType Directory -Path $destRoot -Force | Out-Null
Copy-Item -LiteralPath $src -Destination $destRoot -Recurse -Force

$ok = Test-Path -LiteralPath (Join-Path $destRoot 'alzip-compress\SKILL.md')
Write-Host ("설치 " + $(if($ok){'완료'}else{'실패'}) + ": " + (Join-Path $destRoot 'alzip-compress'))
if ($ok) { Write-Host "Claude Code 새 세션/재시작 후 모든 프로젝트에서 '압축해줘 / 풀어줘' 또는 /alzip-compress 로 사용." }
