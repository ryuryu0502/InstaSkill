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

# 2. 未解決Issue確認
ls .github/ISSUES/

# 3. 権限設定確認
cat .claude/settings.local.json

# 4. 最新の作業内容確認
ls -la Work/ | tail -10
```

## ディレクトリ構造

```
/
├── .claude/
│   ├── settings.local.json    # ローカル権限設定（git管理外）
│   └── skills/
│       └── gramaddict/
│           └── SKILL.md       # GramAddict スキル定義
├── .github/
│   └── ISSUES/                # GitHub Issue 草案（マークダウン）
├── Work/                      # 調査レポート
│   ├── gramaddict-research-01-overview.md
│   ├── gramaddict-research-02-config.md
│   ├── gramaddict-research-03-troubleshooting.md
│   ├── gramaddict-research-04-changelog.md
│   ├── gramaddict-research-05-plugins-architecture.md
│   ├── gramaddict-research-06-core-engine.md
│   ├── gramaddict-research-07-device-facade.md
│   └── skill-test-report.md   # スキルテスト結果
├── README.md
├── test_bot.py                # テスト用スクリプト
└── CLAUDE.md                  # ← イマココ
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
      "Bash(ls *)",
      "Bash(cat *)",
      "Bash(echo *)",
      "Bash(rm .github/ISSUES/*.md)",
      "Bash(mv .github/ISSUES/*.md .github/ISSUES/archived/)",
      "Read(//**)"
    ]
  }
}
```

## 注意事項

- **Instagram ボットは実際には実行できません**（Android デバイスが必要）。このリポジトリは調査と知識の整理が目的
- `test_bot.py` はスキルテスト用のモック。実際の GramAddict コードではない
- `gh` CLI がインストールされていれば、Issue 作成に使用可能
- Python 3.10 は GramAddict 非対応。3.6〜3.9 を使用
- スキル SKILL.md のバージョン情報は `pip3 show gramaddict` で確認して更新すること
