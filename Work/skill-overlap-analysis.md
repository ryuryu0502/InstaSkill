# スキル重複分析レポート

> **発行日**: 2026-06-02
> **対象 Issue**: [Issue 2: スキル重複整理提案](../.github/ISSUES/02-skill-overlap.md)

## 分析サマリー

code-review / review / simplify / security-review の4スキルは「コードレビュー」の大枠で一部機能が重複している。
本レポートでは各スキルの実体を調査し、統合の可否を分析する。

## 各スキルの実体

| スキル | 種別 | 本質的な役割 | 重複度 |
|--------|------|-------------|--------|
| **code-review** | ビルトイン | バグ検出 + クリーンアップ。`--fix` / `--comment` フラグ対応。7角度分析 | — |
| **review** | ビルトイン | Pull Request レビュー | high |
| **simplify** | ビルトイン | リファクタリング専用（code-review --fix の一部） | very high |
| **security-review** | ビルトイン | セキュリティ専門レビュー | medium |

## 詳細分析

### 1. code-review と simplify の重複

- `code-review --fix` は simplify と**ほぼ同一機能**
- simplify は「バグ検出は行わず、品質改善のみ」と明確に差別化されている
- ただし、code-review の `--fix` モードが simplify の役割を完全にカバー
- **判定**: simplify は code-review に統合可能

### 2. code-review と review の重複

- review は「PR レビュー」で code-review と差別化している
- しかし、code-review も `--comment` フラグで PR にインラインコメント投稿可能
- **判定**: review の機能差は薄い。統合可能だが、`gh pr review` ワークフローとの整合性は別途検証が必要

### 3. code-review と security-review の重複

- security-review は「セキュリティ専門レビュー」で、code-review がカバーしない脆弱性診断に特化
- 独立させる価値はあるが、code-review のサブモードとしても実現可能
- **判定**: 独立維持か code-review --security か、判断が分かれる

## 推奨事項

### 推奨: code-review にモード統合

```
code-review                    # 現行: バグ検出 + クリーンアップ
├── code-review --refactor     # = 現 simplify（リファクタリング専用）
├── code-review --security     # = 現 security-review（セキュリティ専門）
├── code-review --comment      # = 現 review（PRコメント投稿）
└── code-review --fix          # 現行維持（自動修正）
```

### スキル設定

不要になったスキルは `skillOverrides` で非表示にできる：

```json
{
  "skillOverrides": {
    "simplify": "off",
    "review": "off",
    "security-review": "user-invocable-only"
  }
}
```

### 判断根拠

1. **simplify → off**: code-review --fix が完全カバー
2. **review → off**: code-review --comment で代替。PRコンテキストは /review で
3. **security-review → user-invocable-only**: ユーザーが明示的に呼ぶ価値あり。モデルへの自動提案は不要

## 未完了項目

- [ ] simplify の --refactor モード化: ビルトインスキルなので変更不可。プロジェクト側で設定可能
- [ ] review スキルの生存確認: `claude code-review --help` と `claude review --help` の出力比較
- [ ] skillOverrides の動作検証
