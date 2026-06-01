# Issue 2: code-review / review / simplify / security-review の重複整理提案

## 問題
以下の4スキルが「コードレビュー」という大枠で役割重複しており、ユーザーが混乱します：

| スキル | 役割 |
|--------|------|
| **code-review** | バグ検出 + クリーンアップ |
| **review** | Pull Request レビュー（差別化不明瞭） |
| **simplify** | コード簡略化（code-review --fix の一部） |
| **security-review** | セキュリティ専門レビュー |

## 提案

### code-review に統合（推奨）
```
code-review
  ├── 通常モード（現行: バグ + cleanup）
  ├── --security モード（現 security-review の機能）
  ├── --refactor モード（現 simplify の機能）
  └── review は code-review に完全統合して削除
```

### 理由
- `code-review --fix` は既に simplify の機能をカバー
- security-review は独立させる価値あり（セキュリティ専門）
- review だけは差別化が困難 → code-review に統合

## タスク
- [x] review スキルの code-review への統合可否を確認 → Work/skill-overlap-analysis.md
- [ ] simplify の --refactor モード化を検討（ビルトインのためプロジェクト側で設定）
- [x] 不要スキルの非表示設定 (`skillOverrides`) を検討 → Work/skill-overlap-analysis.md
- [ ] skillOverrides の動作検証（実機確認）
