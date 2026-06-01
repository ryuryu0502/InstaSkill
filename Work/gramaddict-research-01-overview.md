# GramAddict Bot - 調査レポート フェーズ1

## プロジェクト概要

- **名称**: GramAddict
- **最新バージョン**: 3.2.12 (2024年3月22日)
- **テスト済みInstagram**: 300.0.0.29.110
- **ライセンス**: MIT
- **リポジトリ**: https://github.com/GramAddict/bot
- **スター**: 1.6k, フォーク: 258
- **コミット**: 722+, リリース: 52
- **Python**: 3.6+ (3.10非対応)
- **ドキュメント**: https://docs.gramaddict.org

## 概要

GramAddictは、AndroidのADBインターフェースを通じてInstagramアプリを自動操作する無料のオープンソースボット。
UIAutomator2を使用して人間らしい操作をシミュレートする。
InstagramのAPIを一切使用せず、実際のアプリUIを操作するため、APIベースのボットより安全とされる。

## 主要機能

- Android 5.0+対応、root不要
- 物理デバイス + エミュレータ(Memu, LDPlayer, Android Studio AVD)対応
- 人間らしい動作: ランダム遅延、1文字ずつのタイピング、ストーリー視聴、カルーセルブラウジング
- インタラクション: フォロー/アンフォロー、いいね、コメント(絵文字+スピンタックス)、DM送信
- ソース: フォロワー/フォロー中、ハッシュタグ投稿/いいね、場所投稿/いいね、フィード、カスタムリスト
- アンフォローモード: 全フォロワー、ボットフォロー、非相互フォロー、リスト指定
- フィルタリング: ブラックリスト/ホワイトリスト、プロフィール言語/文字、アカウントタイプ、フォロワー数
- スケジューラー、Telegramレポート、Termuxスタンドアロン対応

## アーキテクチャ

```
GramAddict/bot/
├── GramAddict/
│   ├── __init__.py          # run(), version=3.2.12
│   ├── __main__.py          # CLI: init, run, dump
│   ├── core/                # 20モジュール (エンジン)
│   │   ├── bot_flow.py      # メインループ
│   │   ├── config.py        # YAML/CLI設定
│   │   ├── decorators.py    # @run_safely デコレータ
│   │   ├── device_facade.py # UIAutomator2ラッパー
│   │   ├── interaction.py   # 全インタラクションロジック
│   │   ├── filter.py        # プロフィールフィルタリング
│   │   ├── session_state.py # セッション追跡
│   │   ├── plugin_loader.py # プラグイン自動検出
│   │   ├── handle_sources.py# ソース処理
│   │   ├── navigation.py    # UI画面遷移
│   │   ├── views.py         # UIビュー抽象化
│   │   └── ...
│   └── plugins/             # 15プラグイン + テンプレート
│       ├── interact_hashtag_likers.py
│       ├── interact_hashtag_posts.py
│       ├── interact_blogger.py
│       ├── interact_blogger_followers.py
│       ├── interact_feed.py
│       ├── action_unfollow_followers.py
│       ├── telegram.py
│       └── ...
├── config-examples/         # 7設定テンプレート
├── run.py                   # 最小ランチャー
└── requirements.txt
```

## CLI

```
gramaddict init <account_name>     # アカウント設定の初期化
gramaddict run --config <path>     # ボット実行
gramaddict dump [--device <id>]    # デバッグ画面ダンプ
gramaddict --version               # バージョン表示
```

## 依存関係

| パッケージ | バージョン | 用途 |
|-----------|-----------|------|
| uiautomator2 | ~=2.16.19 | Android UI自動化 |
| colorama | 0.4.4 | カラー端末出力 |
| ConfigArgParse | 1.5.3 | 設定ファイル対応引数解析 |
| PyYAML | 6.0.1 | YAML設定解析 |
| emoji | 1.6.1 | 絵文字処理 |
| langdetect | 1.0.9 | プロフィール言語検出 |
| spintax | 1.0.4 | スピンタックス解析 |
| requests | ~=2.31.0 | HTTP通信 |
| atomicwrites | 1.4.0 | アトミックファイル書込 |
| packaging | ~=20.9 | バージョン文字列解析 |
