# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

GramAddict Instagram 自動化ボットの完全調査レポート & Claude Code スキルリポジトリ。

- **GramAddict**: Android ADB + UIAutomator2 経由で Instagram アプリを自動操作するOSS
- **バージョン**: 3.2.12 (2024-03-22)
- **公式リポジトリ**: https://github.com/GramAddict/bot
- **Python**: 3.6-3.9 推奨（3.10非対応）

## セッション再開時のファーストステップ

```bash
# 1. プロジェクト状態確認
git status
git log --oneline -5

# 2. 権限設定確認
cat .claude/settings.local.json

# 3. セッション初期化（推奨）
bash .claude/init_session.sh

# 4. GitHub Issues 確認（ブラウザで）
#    https://github.com/ryuryu0502/InstaSkill/issues
```

## ディレクトリ構造

```
/
├── .claude/
│   ├── settings.local.json       # ローカル権限設定（git管理外）
│   ├── init_session.sh           # セッション再開初期化スクリプト
│   └── skills/
│       └── gramaddict/
│           ├── SKILL.md          # GramAddict スキル定義
│           ├── templates/        # 設定テンプレート
│           │   ├── config.yml
│           │   ├── filters.yml
│           │   └── comments_list.txt
│           └── scripts/
│               └── check_version.sh  # バージョン確認
├── .github/
│   └── ISSUES/
│       └── archived/            # GitHub Issue 草案（登録済み）
├── Work/                        # 調査レポート
│   ├── gramaddict-research-01-overview.md
│   ├── gramaddict-research-02-config.md
│   ├── gramaddict-research-03-troubleshooting.md
│   ├── gramaddict-research-04-changelog.md
│   ├── gramaddict-research-05-plugins-architecture.md
│   ├── gramaddict-research-06-core-engine.md
│   ├── gramaddict-research-07-device-facade.md
│   ├── skill-test-report.md     # スキルテスト結果
│   └── skill-overlap-analysis.md # スキル重複分析
├── README.md
├── test_bot.py                  # テスト用スクリプト
└── CLAUDE.md                    # ← イマココ
```

## 使用可能なスキル

| スキル | 呼び出し方 | 用途 |
|--------|-----------|------|
| gramaddict | `GramAddict` / `インスタ自動化` | GramAddict bot の設定・実行・トラブルシュート |
| deep-research | `deep-research` | マルチソース調査レポート生成 |
| code-review | `code-review` | コードレビュー（バグ検出） |
| update-config | `update-config` | settings.json の設定変更 |
| security-review | `security-review` | セキュリティレビュー |

## 必要な権限設定

他の Claude Code インスタンスが実行する際、以下を `.claude/settings.local.json` に設定：

```json
{
  "permissions": {
    "allow": [
      "Skill(deep-research)",
      "Workflow(deep-research)",
      "WebSearch",
      "WebFetch(domain:*)",
      "Bash(git *)",
      "Bash(gh *)",
      "Bash(ls *)",
      "Bash(cat *)",
      "Bash(echo *)",
      "Bash(head *)",
      "Bash(tail *)",
      "Bash(python *)",
      "Bash(pip *)",
      "Read(//**)"
    ],
    "ask": [
      "Bash(sudo *)",
      "Bash(adb *)",
      "Bash(kill *)"
    ]
  }
}
```

## 注意事項

- **Instagram ボットは実際には実行できません**（Android デバイスが必要）。このリポジトリは調査と知識の整理が目的
- `test_bot.py` はスキルテスト用のモック。実際の GramAddict コードではない
- `gh` CLI で GitHub Issues / PR を操作可能（`gh auth login` で認証）
- Python 3.10 は GramAddict 非対応。3.6〜3.9 を使用
- スキル SKILL.md のバージョン情報は `pip3 show gramaddict` で確認して更新すること
- Issue 草案は `.github/ISSUES/archived/` に保存済み（GitHub 上に登録済み）
- セッション再開時は `bash .claude/init_session.sh` を推奨
