---
name: gramaddict
description: GramAddict Instagram bot のセットアップ、設定、実行、トラブルシューティングを支援するスキル。このスキルは、ユーザーが "GramAddict", "gramaddict", "Instagram bot", "IG bot", "インスタ自動化", "インスタボット", "UIAutomator2 Instagram" について質問したときに使用する。
tools: Read, Write, Edit, Bash, Glob, Grep, WebFetch, WebSearch
---

# GramAddict スキル

GramAddict は Android の ADB + UIAutomator2 経由で Instagram アプリを自動操作する無料のオープンソースボット。
Instagram API を使わず実際のアプリ UI を操作するため、API ベースのボットより安全とされる。

- **リポジトリ**: https://github.com/GramAddict/bot
- **最新バージョン**: 3.2.12 (2024-03-22)
- **テスト済み Instagram**: 300.0.0.29.110
- **Python**: 3.6+ (3.10 は非対応)
- **ドキュメント**: https://docs.gramaddict.org

## 前提条件

- Android 5.0+ デバイスまたはエミュレータ（root 不要）
- Instagram アプリの言語を **英語** に設定（必須）
- Python 3.6〜3.9（3.10 は非対応）
- ADB (Android Debug Bridge)
- PC または Raspberry Pi（Termux を使えばスマホ単独でも可）

## クイックスタート

### pip インストール（推奨）

```bash
# 仮想環境を作成
python3 -m venv .venv
source .venv/bin/activate  # Linux/macOS
# .venv\Scripts\activate.bat  # Windows

# インストール
pip3 install gramaddict

# 確認
gramaddict --version
```

### ADB セットアップ

1. [Android Platform Tools](https://developer.android.com/studio/releases/platform-tools) をダウンロード・展開
2. 展開先をシステム PATH に追加
3. 確認: `adb version`

### Android デバイス設定

1. 開発者オプションを有効化（設定 → 端末情報 → ビルド番号を7回タップ）
2. USBデバッグを有効化
3. USB 接続してデバイス側で許可
4. 確認: `adb devices`

### 初期化と実行

```bash
# UIAutomator2 の初期化
python3 -m uiautomator2 init

# アカウント設定を生成
gramaddict init <instagram_username>

# 設定ファイルを編集
# accounts/<username>/config.yml
# accounts/<username>/filters.yml

# 実行
gramaddict run --config accounts/<username>/config.yml
```

## ディレクトリ構造

```
.
├── accounts/
│   └── <username>/
│       ├── config.yml          # メイン設定（必須）
│       ├── filters.yml         # プロフィールフィルタリング
│       ├── telegram.yml        # Telegram レポート認証
│       ├── comments_list.txt   # コメントテンプレート（スピンタックス対応）
│       ├── pm_list.txt         # DM テンプレート
│       ├── blacklist.txt       # 絶対に接触しないユーザー
│       └── whitelist.txt       # アンフォローから保護するユーザー
└── sessions.json               # セッション履歴（自動生成）
```

## 設定ファイル: config.yml

### 安全な設定テンプレート（推奨）

```yaml
# === 一般設定 ===
username: your_instagram_username
device: null                    # 複数デバイス時のみ指定
app-id: com.instagram.android
allow-untested-ig-version: false
screen-sleep: true
speed-multiplier: 1
close-apps: false               # Termux では false 必須
restart-atx-agent: true         # 安定性向上に推奨
shuffle-jobs: true              # ジョブ順をランダム化
truncate-sources: 2-5           # ソースを一部だけランダム使用

# === インタラクションジョブ（少なくとも1つ必要） ===
# ハッシュタグ（人気投稿の投稿者）
hashtag-posts-top: [ travel, photography, food ]
# ハッシュタグ（人気投稿のいいねユーザー）
hashtag-likers-top: [ travel, photography ]
# ブロガーのフォロワー
# blogger-followers: [ username1, username2 ]
# 自分のフィード（数値はいいね数）
# feed: 2-5

# === ジョブ修飾子 ===
watch-video-time: 15-35
watch-photo-time: 3-4

# === アンフォロージョブ ===
unfollow-non-followers: 10-20
unfollow-delay: 15

# === ソース制限 ===
interactions-count: 30-40
likes-count: 1-2
likes-percentage: 100
stories-count: 1-2
stories-percentage: 30-40
carousel-count: 2-3
carousel-percentage: 60-70
max-comments-pro-user: 1-2
interact-percentage: 30-40
follow-percentage: 30-40
follow-limit: 50
skipped-list-limit: 10-15

# === セッション総制限（安全マージン） ===
total-likes-limit: 120-150
total-follows-limit: 40-50
total-unfollows-limit: 40-50
total-watches-limit: 120-150
total-successful-interactions-limit: 120-150
total-interactions-limit: 280-300

# === セッション終了条件 ===
end-if-likes-limit-reached: true
end-if-follows-limit-reached: false
end-if-watches-limit-reached: false

# === スケジューリング ===
working-hours: [10.15-16.40, 18.15-22.46]
time-delta: 10-15
repeat: 280-320
total-sessions: -1              # -1 = 無限
```

### 全インタラクションソース一覧

| 設定キー | 対象 | 例 |
|---------|------|-----|
| `blogger-followers` | 指定ユーザーのフォロワー | `[user1, user2]` |
| `blogger-following` | 指定ユーザーのフォロー中 | `[user1, user2]` |
| `blogger-post-likers` | 指定ユーザーの投稿にいいねした人 | `[user1, user2]` |
| `blogger` | 指定ユーザーと直接交流 | `[user1, user2]` |
| `hashtag-likers-top` | ハッシュタグ人気投稿のいいねユーザー | `[tag1, tag2]` |
| `hashtag-likers-recent` | ハッシュタグ新着投稿のいいねユーザー | `[tag1, tag2]` |
| `hashtag-posts-top` | ハッシュタグ人気投稿の投稿者 | `[tag1, tag2]` |
| `hashtag-posts-recent` | ハッシュタグ新着投稿の投稿者 | `[tag1, tag2]` |
| `place-likers-top` | 場所人気投稿のいいねユーザー | `[place1]` |
| `place-posts-top` | 場所人気投稿の投稿者 | `[place1]` |
| `interact-from-file` | ファイルからユーザー指定 | `[list.txt 10-15]` |
| `posts-from-file` | ファイルから投稿指定 | `posts.txt` |
| `feed` | 自分のフィード | `2-5` |

### 全アンフォロージョブ

| 設定キー | 説明 |
|---------|------|
| `unfollow` | ボットがフォローしたユーザーのみ |
| `unfollow-any` | 誰がフォローしたかに関わらず全員対象 |
| `unfollow-non-followers` | ボット経由フォローで非相互のみ |
| `unfollow-any-non-followers` | 全ユーザー中で非相互のみ |
| `unfollow-any-followers` | フォロバされている人もアンフォロー |
| `unfollow-from-file` | ファイル指定 |

## 設定ファイル: filters.yml

```yaml
# === プロフィールタイプ ===
skip_if_private: false
skip_if_public: false
skip_business: true             # ビジネスアカウント除外
skip_non_business: false
skip_following: true            # 既にフォロー中を除外
skip_follower: true             # 既にフォロワーを除外
skip_if_link_in_bio: true       # プロフにリンクあり除外

# === プロフィール統計 ===
min_followers: 50
max_followers: 2500
min_followings: 50
max_followings: 2500
min_potency_ratio: 0.5          # フォロワー/フォロー中比率の下限
max_potency_ratio: 5            # 同上限（スパム除外）
min_posts: 3
mutual_friends: -1              # -1 = 無効

# === プロフィール文フィルター ===
blacklist_words: [sex, link]
mandatory_words: []             # 全必須ワード
specific_alphabet: [LATIN]      # 許可文字種
biography_language: [ja, en]    # 許可言語（ISO 639-1）
biography_banned_language: []

# === コメント有効化 ===
comment_photos: true
comment_videos: true
comment_carousels: true

# === いいね数フィルター ===
min_likers: 1
max_likers: 1000
```

## コメントと DM（スピンタックス対応）

### comments_list.txt 形式

```
%PHOTO
{素敵|いい|最高の}写真ですね{！|!!}
{Nice|Great|Beautiful} shot{!|!!}
%VIDEO
動画{楽しかった|すごかった|良かった}です{！|!!}
%CAROUSEL
{素敵な|良い|最高の}投稿ですね{！|!!}
```

### pm_list.txt 形式

```
こんにちは！{素敵な|良い}投稿に惹かれてメッセージしました{！|!!}
Hello! I {really |}like your {posts|feed|photos}{!|!!}
```

- `{A|B|C}` → A, B, C のいずれかがランダム選択
- ネスト対応: `{{S|s}pintax|spin syntax}`
- 絵文字対応（`:smile:` 形式）

## 実行と監視

### CLI

```bash
gramaddict init <username>              # アカウント設定を初期化
gramaddict run --config <config.yml>    # ボット実行
gramaddict dump [--device <id>]         # 画面ダンプ（デバッグ用）
gramaddict --version                    # バージョン表示
```

### 実行中の制御

- `Ctrl+C` 1回: 一時停止（続行/停止を選択可能）
- `Ctrl+C` 2回: 強制終了

### Telegram レポート設定

```yaml
# telegram.yml
telegram-api-token: 123456789:ABCDEFGHILMNOPQRSTUVZ-1AB2CD3
telegram-chat-id: -123456789
```

```yaml
# config.yml に追記
telegram-reports: true
```

## トラブルシューティング

### 1. `adb devices` が空 / デバイスが認識されない

```bash
adb kill-server
adb start-server
adb devices
```

**Termux の場合（6ステップ）:**
```bash
# PC で:
adb tcpip 5555
adb kill-server
# USB 切断後、Termux で:
adb connect localhost:5555
adb devices
```

### 2. Termux でボットがフリーズする

**原因**: `close-apps` が Termux と競合
**修正**: `config.yml` で `close-apps: false` に設定（必須）

### 3. uiautomator2 がクラッシュ（UiAutomationNotConnectedError）

```yaml
# config.yml に追加
restart-atx-agent: true
```

または:
```bash
adb shell pkill atx-agent
pip3 install uiautomator2 --upgrade
python3 -m uiautomator2 init
```

### 4. Instagram が開くが何も起きない

```yaml
# config.yml に追加
allow-untested-ig-version: true
restart-atx-agent: true
```

### 5. Python 3.10 で動作しない

Python 3.9 にダウングレード。3.10 は非対応。

### 6. Windows パスにスペースがある

```bash
gramaddict run --config "C:\Users\My Name\bot\config.yml"
```

### 7. 画面ロックがあると screen-sleep が効かない

パスコード/パターンを解除するか、手動で解除してから実行。

### 8. ボットが突然停止する

`total-crashes-limit` を確認（デフォルト5）。ログでクラッシュ原因を特定。

## Termux スマホ単独実行

```bash
# Termux を F-Droid からインストール

# パッケージインストール
pkg update
pkg install android-tools python build-essential cmake libjpeg-turbo libpng libxml2 libxslt freetype git
pip install wheel

# GramAddict をクローン
git clone https://github.com/GramAddict/bot.git
cd bot
pip install -r requirements.txt

# ADB 設定（PC で一度だけ必要）
# PC で: adb tcpip 5555
# Termux で: adb connect localhost:5555

# 初期化と実行
python -m uiautomator2 init
python run.py --config accounts/<username>/config.yml
```

**重要**: Termux では `close-apps: false` が必須。設定ファイル編集には FX File Explorer を使用。

## アカウント安全のベストプラクティス

### 安全な運用パターン

1. **範囲指定でランダム化**: すべての数値を `min-max` 形式で指定
2. **フォロー率を下げる**: `follow-percentage: 30-40`（全員フォローしない）
3. **インタラクション率を下げる**: `interact-percentage: 30-40`（プロフィールを見てもスキップ多めに）
4. **人間らしい時間帯**: `working-hours` で昼夜の時間帯を指定
5. **ジョブのランダム化**: `shuffle-jobs: true`
6. **ソースを絞る**: `truncate-sources: 2-5`
7. **通知をオフ**: Instagram の通知がボット操作を妨げるため

### 2アカウント安全戦略（スクレイピング）

1. サブアカウントでユーザー収集のみ:
   ```yaml
   scrape-to-file: scraped.txt
   ```
2. メインアカウントで収集済みリストにのみ交流:
   ```yaml
   interact-from-file: [scraped.txt 10-15]
   ```

### BAN リスクを高める行為

- 短期間での大量アクション
- `follow-percentage: 100`
- すべての数値を固定値に（範囲指定しない）
- `working-hours` なしで24時間稼働
- API ベースのボットとの併用

## アーキテクチャ

```
GramAddict/
├── core/                    # 20モジュール（エンジン）
│   ├── bot_flow.py          # メインループ
│   ├── interaction.py       # 全インタラクションロジック
│   ├── filter.py            # プロフィールフィルタリング
│   ├── session_state.py     # セッション状態・制限管理
│   ├── handle_sources.py    # フォロワー/投稿一覧取得
│   ├── navigation.py        # 画面遷移（5関数）
│   ├── views.py             # UIビュー抽象化（18クラス）
│   ├── device_facade.py     # UIAutomator2 ラッパー
│   ├── resources.py         # 103 UIリソースID + タブ文字列
│   ├── plugin_loader.py     # プラグイン自動検出
│   ├── decorators.py        # @run_safely デコレータ
│   └── scroll_end_detector.py # スクロール終了検出
└── plugins/                 # 15プラグイン
    ├── interact_hashtag_posts.py
    ├── interact_blogger_followers.py
    ├── action_unfollow_followers.py
    ├── telegram.py
    ├── interact_feed.py
    └── ...
```

### 主要な設計パターン

- **プラグイン自動検出**: `plugins/` に `.py` を置くだけで自動登録
- **@run_safely**: 例外発生時の自動リトライ + クラッシュレポート保存
- **functools.partial**: コア関数に設定を注入するパターン
- **ScrollEndDetector**: 同一ユーザーリストの連続出現で終端判定
- **ResourceID 複合セレクタ**: `|` 区切りで UI バージョン差異を吸収
- **リングバッファ録画**: クラッシュ時のみ直近30秒を保存

## エミュレータ別設定

| エミュレータ | プラットフォーム | 備考 |
|------------|---------------|------|
| Memu | Windows | 推奨 |
| LDPlayer | Windows | |
| Android Studio AVD (Pixel 2 API 28) | macOS | 推奨 |

エミュレータ使用時は `config.yml` の `device` にエミュレータのADBデバイスIDを指定する。

## 参考文献

- 公式ドキュメント: https://docs.gramaddict.org
- GitHub: https://github.com/GramAddict/bot
- Discord: https://discord.gg/9MTjgs8g5R
- 設定リファレンス: https://docs.gramaddict.org/#/configuration
- Termux ガイド: https://docs.gramaddict.org/#/termux
