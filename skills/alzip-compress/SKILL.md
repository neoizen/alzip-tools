---
name: alzip-compress
description: >-
  파일/폴더를 압축하거나 압축을 해제할 때 사용한다. Windows에서 이스트소프트 알집 CLI(ALZipCon.exe)를
  우선 사용한다. "압축해줘", "압축 풀어줘/해제", "zip/egg/alz로 묶어줘", "아카이브 만들어/풀어" 같은 요청에 발동.
---

# 알집(ALZipCon)으로 압축 / 해제

이 환경(Windows)에서 파일 **압축·해제는 알집 CLI `ALZipCon.exe`를 우선 사용**한다.
(이 문법은 2026-06-17 실제 실행으로 검증됨.)

## 실행 파일
- 경로: `C:\Program Files (x86)\ESTsoft\ALZip\ALZipCon.exe` (PATH에 없음 → **전체 경로**로 호출)
- PowerShell 호출 예: `& "C:\Program Files (x86)\ESTsoft\ALZip\ALZipCon.exe" <인자...>`
- 위 경로에 없으면: `${env:ProgramFiles(x86)}\ESTsoft\ALZip\ALZipCon.exe` 또는 레지스트리 InstallLocation으로 찾는다.
  그래도 없으면 사용자에게 알리고 **대체 도구로 폴백**(아래 "폴백").

## 검증된 문법
| 동작 | 문법 |
|------|------|
| 압축 | `ALZipCon.exe -a <원본>[;<원본2>…] <출력.확장자>` |
| 해제 | `ALZipCon.exe -x <아카이브> <대상폴더>` |
| 검사 | `ALZipCon.exe -t <아카이브>` |

규칙(실측):
- **확장자가 포맷을 결정**한다: `.egg`(알집 기본)·`.alz`·`.zip` 등.
- **여러 원본은 `;`로 구분**(공백 없이). 경로에 공백이 있으면 **따옴표로 감싼다**.
- **폴더 통째 압축 가능**(폴더 자체가 아카이브에 포함됨).
- **해제는 대상폴더 아래에 "아카이브명 하위폴더"를 만들고** 저장된 구조 그대로 푼다.
  예: `-x folder.zip C:\dest` → `C:\dest\folder\...`. 사용자가 특정 위치에 바로 풀길 원하면 이 하위폴더를 감안한다.
- **종료코드 0 = 성공**, 0이 아니면(예: 4) 실패 → 인자·경로·포맷 확인. (`-e`는 해제 플래그가 아님 → 4)

## 절차 — 있으면 알집 / 없으면 폴백 + 동의 시 설치
1. **알집 존재 확인**: `Test-Path "C:\Program Files (x86)\ESTsoft\ALZip\ALZipCon.exe"`. 없으면 `${env:ProgramFiles(x86)}\ESTsoft\ALZip\ALZipCon.exe`·레지스트리 InstallLocation도 확인.
2. **있으면 → 알집으로 처리**: 위 검증된 문법(`-a`/`-x`/`-t`)으로 ALZipCon 실행 → **종료코드(0)와 결과 파일/폴더 생성**을 확인(실행만 하고 끝내지 말 것).
3. **없으면 →**
   - (a) **일반 zip/tar 작업**: 아래 **내장 도구로 폴백**한 뒤 "알집이 없어 내장 도구로 처리했다"고 알린다.
   - (b) **`.egg`/`.alz`가 꼭 필요**(내장 도구로 불가): **자동/강제 설치하지 말고** 사용자에게 "알집이 없습니다. 설치할까요?"라고 먼저 묻는다.
     - **동의 시**: altools.co.kr 공식 설치관리자를 받아 **대화형으로 실행**(UAC는 사용자가 승인)하거나 설치 방법을 안내. (사일런트/강제 설치 금지 — 관리자권한 필요·애드웨어 번들 위험.)
     - **거부 시**: 가능한 범위에서 내장 도구로 처리하거나, `.egg`/`.alz`는 불가함을 알린다.
4. 출력 파일을 **덮어쓸 수 있으니** 같은 이름이 있으면 확인 후 진행한다.

## 예시
- 폴더를 zip으로 압축:
  `& "C:\Program Files (x86)\ESTsoft\ALZip\ALZipCon.exe" -a "C:\work\src" "C:\work\out.zip"`
- 여러 파일을 egg로 압축:
  `& "C:\Program Files (x86)\ESTsoft\ALZip\ALZipCon.exe" -a "C:\a.txt;C:\b.txt" "C:\out.egg"`
- 해제:
  `& "C:\Program Files (x86)\ESTsoft\ALZip\ALZipCon.exe" -x "C:\work\out.zip" "C:\work\dest"`
- 무결성 검사:
  `& "C:\Program Files (x86)\ESTsoft\ALZip\ALZipCon.exe" -t "C:\work\out.zip"`

## 폴백 (알집이 없거나 실패할 때) — Windows 내장 도구만 사용
- 압축(zip): `Compress-Archive -Path <원본> -DestinationPath <out.zip>` (zip 전용, 2GB 한계)
- 해제(zip): `Expand-Archive -Path <out.zip> -DestinationPath <dest>`
- tar/zip/gz 등: `tar.exe`(System32, bsdtar) — 예 `tar -xf <archive>`
- 폴백을 쓰면 **"알집 대신 ○○로 처리했다"는 사실을 사용자에게 알린다.**
- (7-Zip 등 제3자 압축 도구는 폴백으로 사용하지 않는다.)

### 알집이 없을 때 설치 정책
- **자동/강제 설치하지 않는다.** (알집은 winget에 없어 패키지매니저 설치 불가, 설치관리자는 관리자권한(UAC) 필요 + 개인용 애드웨어 번들 위험 + 되돌리기 어려운 시스템 변경.)
- `.egg`/`.alz`가 꼭 필요한데 알집이 없으면 → 사용자에게 알리고 **동의를 받은 뒤에만** 설치를 안내/진행한다. 그 외에는 위 내장 폴백으로 처리한다.

## 적용 범위
- **Windows 전용**(`ALZipCon.exe`). macOS/Linux에서는 이 스킬을 쓰지 않고 그 OS의 도구(`ditto`/`zip`/`tar` 등)를 사용한다.
- 자체 포맷 `.egg`/`.alz` 생성·해제가 필요하면 알집이 사실상 유일하므로 이 스킬을 우선한다.
