# Issue 4: gramaddict カスタムスキルの強化提案

## 現状の評価
gramaddict スキル (`SKILL.md`) は非常に高品質。日本語完全対応、全パラメータ網羅、トラブルシューティング完備。

## 強化提案

### 1. テンプレートファイルの同梱
スキルディレクトリに以下を追加すると、他のAIがすぐに実行可能に：
```
.claude/skills/gramaddict/
├── SKILL.md (現行)
├── templates/
│   ├── config.yml          # 安全設定テンプレート
│   ├── filters.yml         # フィルター設定テンプレート
│   └── comments_list.txt   # コメントテンプレート
└── scripts/
    └── check_version.sh    # バージョン確認スクリプト
```

### 2. バージョン情報の自動化
現在 v3.2.12 がハードコードされている。
```yaml
# SKILL.md に追加すべき項目
- **更新確認**: `pip3 show gramaddict | grep Version`
- **相互運用性の注意**: Python 3.10+ では uiautomator2 が非対応
```

### 3. 不足している情報
- Android 15 / iOS との互換性情報
- Instagram API 変更による影響（2025-2026年の変更点）
- 代替OSS（InstaPy, InstagramAPI）との機能比較表
- エミュレータ（Memu / LDPlayer）の日本語設定手順

### 4. エラーパターンの追加
実運用で収集したエラーパターンをスキルにフィードバックする仕組み：
```
# SKILL.md に追加すべきトラブルシューティング
- "Session expired" エラーの対処法
- "Action Blocked" からの復旧手順
- 2要素認証（2FA）の回避方法
```

## タスク
- [x] テンプレートファイルを同梱 → .claude/skills/gramaddict/templates/ (config.yml, filters.yml, comments_list.txt)
- [x] バージョンチェック機構を追加 → .claude/skills/gramaddict/scripts/check_version.sh
- [x] 不足情報を補完 → SKILL.md（代替OSS比較、エミュレータ日本語設定、エラーパターン）
- [x] エラーパターンの継続的収集 → SKILL.md に13パターンを追加
- [ ] pip3 show gramaddict でバージョンを確認して SKILL.md を最新に更新
