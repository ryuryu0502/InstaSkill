# InstaSkill

GramAddict Instagram 自動化ボットの完全調査レポート & Claude Code スキル

## 概要

[GramAddict](https://github.com/GramAddict/bot) は Android の ADB + UIAutomator2 経由で Instagram アプリを自動操作するオープンソースボットです。このリポジトリは GramAddict の網羅的な調査結果と、Claude Code から呼び出せる実用的なスキルファイルを提供します。

## 使い方

### Claude Code スキル

会話内で「GramAddict」や「インスタ自動化」に言及すると、自動的にスキルが読み込まれます。

```bash
# スキルファイル
.claude/skills/gramaddict/SKILL.md

# 設定テンプレート
.claude/skills/gramaddict/templates/config.yml
.claude/skills/gramaddict/templates/filters.yml
.claude/skills/gramaddict/templates/comments_list.txt

# バージョン確認
bash .claude/skills/gramaddict/scripts/check_version.sh

# セッション再開時の初期化
bash .claude/init_session.sh
```

### セッション再開（他の Claude Code に引き継ぐ場合）

プロジェクトルートで Claude Code を起動し、以下のように指示してください：

```
CLAUDE.md を読んで状況を把握し、GitHub Issues の残タスクを確認して進めてください。
```

**状況別の初回プロンプト:**

| 目的 | プロンプト |
|------|-----------|
| 前回の続き | `CLAUDE.md を読んで状況を把握し、GitHub Issues の未完了タスクを確認して進めてください。` |
| 現状分析 | `CLAUDE.md と Work/skill-test-report.md と Work/skill-overlap-analysis.md を読んで現状を教えてください。` |
| GramAddict 質問 | `CLAUDE.md を読んでプロジェクトを把握した上で、GramAddict の設定方法を教えてください。` |
| セッション初期化 | `bash .claude/init_session.sh を実行してから状況を教えてください。` |

> **ポイント**: 必ず最初に「CLAUDE.md を読んで」と明示すると確実です。

### 調査レポート

`Work/` ディレクトリに全調査結果が格納されています：

| ファイル | 内容 |
|---------|------|
| `gramaddict-research-01-overview.md` | プロジェクト概要、アーキテクチャ、CLI、依存関係 |
| `gramaddict-research-02-config.md` | 全設定パラメータ完全リファレンス、フィルター、スピンタックス |
| `gramaddict-research-03-troubleshooting.md` | トラブルシューティング13項目、安全運用ベストプラクティス、Termux手順 |
| `gramaddict-research-04-changelog.md` | v2.6〜v3.2.12 全バージョン履歴（破壊的変更含む） |
| `gramaddict-research-05-plugins-architecture.md` | 15プラグインの設計パターンと実装詳細 |
| `gramaddict-research-06-core-engine.md` | SessionState、ResourceID (103要素)、ナビゲーション、ScrollEndDetector |
| `gramaddict-research-07-device-facade.md` | デバイス抽象化層、画面録画（リングバッファ）、UIビュー (18クラス)、テスト構造 |
| `skill-test-report.md` | 全14スキルの実動テスト結果、コードレビュー検証、改善提案 |
| `skill-overlap-analysis.md` | 4スキル重複分析と統合提案 |

### スキル改善 Issue

以下の Issue を GitHub に登録済みです（[Issues ページ](https://github.com/ryuryu0502/InstaSkill/issues) を参照）。草案は `.github/ISSUES/archived/` に保存されています。

| # | 内容 | GitHub |
|---|------|--------|
| 1 | 全スキル実動テストレポート | [#1](https://github.com/ryuryu0502/InstaSkill/issues/1) |
| 2 | code-review/review/simplify/security-review の重複整理 | [#2](https://github.com/ryuryu0502/InstaSkill/issues/2) |
| 3 | settings.local.json 権限設定の最適化 | [#3](https://github.com/ryuryu0502/InstaSkill/issues/3) |
| 4 | gramaddict カスタムスキル強化提案 | [#4](https://github.com/ryuryu0502/InstaSkill/issues/4) |
| 5 | セッション切断後の再開手順の標準化 | [#5](https://github.com/ryuryu0502/InstaSkill/issues/5) |

### 調査ボリューム

- **8エージェント** の並行調査
- **40+ WebFetch** リクエスト
- カバー範囲: GitHub リポジトリ、ドキュメントサイト、全ソースコードファイル

## 主要リンク

| リンク | URL |
|--------|-----|
| GramAddict リポジトリ | https://github.com/GramAddict/bot |
| 公式ドキュメント | https://docs.gramaddict.org |
| Discord コミュニティ | https://discord.gg/9MTjgs8g5R |
| PyPI | https://pypi.org/project/gramaddict/ |

## ライセンス

MIT
