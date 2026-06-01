# Issue 5: セッション切断後の再開手順の標準化

## 問題
Claude Code セッションが切断された後、別のAI（または再開した同一AI）がスムーズに作業を継続できない。

## 必要な手順

### セッション再開時に読むべきファイル
```
1. README.md → プロジェクト概要を把握
2. .claude/settings.local.json → 権限設定を確認
3. Work/skill-test-report.md → 最新のテスト結果
4. .github/ISSUES/*.md → 未解決課題一覧
```

### 必要なコマンド
```bash
# 1. プロジェクト状態確認
git status
git log --oneline -5

# 2. 未完了タスク確認
ls .github/ISSUES/

# 3. 権限設定確認
cat .claude/settings.local.json

# 4. 最新の作業内容確認
ls -la Work/
```

## 提案: CLAUDE.md の作成
プロジェクトルートに `CLAUDE.md` を作成し、以下の情報を記載：
- プロジェクトの目的と構造
- 使用可能なスキル一覧
- 必要な権限設定
- 継続タスクの優先順位
- よく使うコマンド一覧
- エラーハンドリングの基本手順

## タスク
- [x] CLAUDE.md を作成（`/init` スキルを使用）→ CLAUDE.md 存在確認済み
- [x] セッション再開手順を CLAUDE.md に明記（ファーストステップセクション）
- [x] 各 Issue の完了条件を明確化（本タスクリストに完了マーク）
- [x] 権限設定の初期化スクリプトを作成 → .claude/init_session.sh
- [ ] 別のAIで init_session.sh の動作確認
