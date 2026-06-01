# Issue 3: 権限設定の最適化（settings.local.json）

## 問題
現在の `.claude/settings.local.json` は GramAddict 調査用の権限のみ設定されており、deep-research などのワークフロースキルで頻繁に権限プロンプトが発生します。

## 現状の設定
```json
{
  "permissions": {
    "allow": [
      "Skill(deep-research)",
      "Workflow(deep-research)",
      "WebSearch",
      "Bash(curl ...)"
    ]
  }
}
```

## 提案設定
```json
{
  "permissions": {
    "allow": [
      "Skill(deep-research)",
      "Workflow(deep-research)",
      "WebSearch",
      "WebFetch(domain:*)",
      "Bash(git *)",
      "Bash(python *)",
      "Bash(pip *)",
      "Bash(ls *)",
      "Bash(cat *)",
      "Read(//**)"
    ],
    "ask": [
      "Bash(rm *)",
      "Bash(sudo *)"
    ]
  },
  "env": {
    "DEBUG": "true"
  }
}
```

## セッション再開時に必要な設定
他のAIがこのプロジェクトを引き継ぐ際、以下が必要：
1. `gh` CLI の認証（GitHub Issues / PR 操作）
2. ワークフロースキル（deep-research）の事前許可
3. GramAddict 調査に必要な WebFetch 権限

## タスク
- [x] 汎用権限と専用権限を分離 → .claude/settings.local.json（allow/ask 分割済み）
- [x] セッション再開手順を CLAUDE.md に明記（`設定手順` セクション）
- [x] `ask` リストで危険操作を明示（sudo, adb, kill 等を登録済み）
- [ ] 別のAIで設定の動作確認
