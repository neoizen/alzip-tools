# alzip-tools — alzip-compress 스킬

알집(ALZipCon)으로 파일/폴더를 **압축·해제**하는 Claude Code 스킬. 알집이 없으면 Windows 내장 도구(Compress-Archive/tar)로 폴백.

## 설치 (받는 사람)

### A. 파일로 설치 — Cowork 포함 모든 환경 (권장)
1. 이 저장소를 받는다(`git clone` 또는 ZIP 다운로드).
2. PowerShell에서 설치 스크립트 실행:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\install.ps1
   ```
   → `~/.claude/skills/alzip-compress/` 에 복사된다.
   (수동: `alzip-tools\skills\alzip-compress` 폴더를 `%USERPROFILE%\.claude\skills\` 에 복사)
3. Claude Code **새 세션/재시작** 후 "압축해줘 / 풀어줘"로 사용하거나 `/alzip-compress`.

### B. 플러그인으로 설치 — CLI Claude Code 환경만
```
/plugin marketplace add <owner>/<repo>
/plugin install alzip-tools@alzip-marketplace
```
> ⚠️ Cowork 환경엔 `/plugin` 명령이 없다 → **A 방법(파일 설치)** 을 쓸 것.

## 요구사항 / 동작
- **Windows + 알집(ALZip) 설치** 시 알집(`ALZipCon.exe`)으로 처리.
- 알집이 없으면 → **Windows 내장 도구**(Compress-Archive/Expand-Archive/tar)로 폴백.
- `.egg`/`.alz`가 꼭 필요한데 알집이 없으면 → **동의 후에만 설치 안내**(자동/강제 설치 안 함).
- macOS/Linux에서는 해당 OS 도구로 처리(이 스킬 비적용).

## 구조
```
alzip-marketplace/
├─ install.ps1                                  ← 파일 설치 스크립트(방법 A)
├─ .claude-plugin/marketplace.json             ← (CLI 플러그인용 메타)
└─ alzip-tools/
   ├─ .claude-plugin/plugin.json               ← (CLI 플러그인용 메타)
   └─ skills/alzip-compress/SKILL.md           ← 스킬 본문(검증된 알집 문법)
```

## 올리는 사람용
비공개 git 저장소에 push 후 동료에게 접근 권한을 준다. 상세 절차는 프로젝트 `docs/14-알집스킬-git-배포-설치-가이드.md` 참고.
