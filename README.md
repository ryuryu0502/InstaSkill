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
```

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
