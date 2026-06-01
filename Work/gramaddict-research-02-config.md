# GramAddict Bot - 設定リファレンス完全版

## 設定ファイル一覧

| ファイル | 目的 |
|---------|------|
| `config.yml` | メイン設定 (全自動化動作) |
| `filters.yml` | プロフィールフィルタリングルール |
| `telegram.yml` | Telegramレポート認証情報 |
| `comments_list.txt` | コメントテンプレート (スピンタックス対応) |
| `pm_list.txt` | DMテンプレート (スピンタックス対応) |
| `blacklist.txt` | 絶対に接触しないユーザー |
| `whitelist.txt` | アンフォローから保護するユーザー |

## config.yml 全セクション

### 一般設定
- `username`: Instagramアカウント名 (必須)
- `device`: デバイスID (複数接続時のみ)
- `app-id`: アプリパッケージID (default: com.instagram.android)
- `use-cloned-app`: クローンアプリ使用 (false)
- `allow-untested-ig-version`: 未テストIG警告を抑制 (false)
- `screen-sleep`: 終了後画面オフ (false)
- `screen-record`: 画面録画 (false)
- `speed-multiplier`: 速度倍率 (1)
- `debug`: デバッグ出力 (false)
- `close-apps`: バックグラウンドアプリを閉じる (true) ⚠️ Termuxではfalse必須
- `kill-atx-agent`: セッション後atxエージェント終了 (false)
- `restart-atx-agent`: セッション前atxエージェント再起動 (false) ★安定性向上に推奨
- `disable-filters`: フィルター無効化 (false)
- `disable-block-detection`: ブロック検出無効化 (false)
- `dont-type`: タイピングせずペースト (false)
- `scrape-to-file`: ユーザー名収集モード (ファイル名)
- `total-crashes-limit`: 許容クラッシュ数 (5)
- `count-app-crashes`: アプリクラッシュをカウント (false)
- `shuffle-jobs`: ジョブ順序ランダム化 (false)
- `truncate-sources`: ソースをN個に制限 (0=無効)

### インタラクションジョブ (操作対象)
- `blogger-followers`: 指定ユーザーのフォロワーと交流
- `blogger-following`: 指定ユーザーのフォロー中と交流
- `blogger-post-likers`: 指定ユーザーの投稿にいいねした人と交流
- `blogger`: 指定ユーザーと直接交流
- `hashtag-likers-top`: ハッシュタグ人気投稿のいいねユーザー
- `hashtag-likers-recent`: ハッシュタグ新着投稿のいいねユーザー
- `hashtag-posts-top`: ハッシュタグ人気投稿の投稿者
- `hashtag-posts-recent`: ハッシュタグ新着投稿の投稿者
- `place-likers-top`: 場所人気投稿のいいねユーザー
- `place-likers-recent`: 場所新着投稿のいいねユーザー
- `place-posts-top`: 場所人気投稿の投稿者
- `place-posts-recent`: 場所新着投稿の投稿者
- `interact-from-file`: テキストファイルからユーザー指定
- `posts-from-file`: テキストファイルから投稿指定
- `feed`: フィード交流 (いいね数指定)

### ジョブ修飾子
- `watch-video-time`: 動画視聴時間(秒) (15-35)
- `watch-photo-time`: 写真視聴時間(秒) (3-4)
- `can-reinteract-after`: 再インタラクション間隔(時間)
- `delete-interacted-users`: 処理済みユーザーをソースファイルから削除

### アンフォロージョブ
- `unfollow`: ボットがフォローしたユーザーをアンフォロー
- `unfollow-any`: 任意のユーザーをアンフォロー
- `unfollow-non-followers`: 非相互フォローをアンフォロー
- `unfollow-any-non-followers`: 任意の非相互をアンフォロー
- `unfollow-any-followers`: 任意のフォロワーをアンフォロー
- `unfollow-from-file`: ファイル指定でアンフォロー

### ソース制限
- `interactions-count`: ソース毎のインタラクション数 (70)
- `likes-count`: ユーザー毎のいいね数 (2)
- `likes-percentage`: いいね確率 (100)
- `stories-count`: ストーリー視聴数 (0)
- `stories-percentage`: ストーリー視聴確率 (30)
- `carousel-count`: カルーセルブラウズ数 (0)
- `carousel-percentage`: カルーセルブラウズ確率 (0)
- `max-comments-pro-user`: ユーザー毎の最大コメント数 (0)
- `comments-percentage`: コメント確率 (0)
- `pm-percentage`: DM確率 (0)
- `interact-percentage`: インタラクション確率 (50)
- `follow-percentage`: フォロー確率 (0)
- `follow-limit`: ソース毎のフォロー上限 (0)
- `skipped-list-limit`: スキップ許容数 (10-15)
- `skipped-posts-limit`: 投稿スキップ許容数 (5)

### セッション総制限
- `total-likes-limit`: 総いいね数 (300)
- `total-follows-limit`: 総フォロー数 (50)
- `total-unfollows-limit`: 総アンフォロー数 (50)
- `total-watches-limit`: 総ストーリー視聴数 (50)
- `total-successful-interactions-limit`: 成功インタラクション総数 (100)
- `total-interactions-limit`: 総インタラクション数 (1000)
- `total-comments-limit`: 総コメント数 (300)
- `total-pm-limit`: 総DM数 (300)
- `total-scraped-limit`: 総スクレイピング数 (300)

### スケジューリング
- `working-hours`: 稼働時間帯 [10.15-16.40, 18.15-22.46]
- `time-delta`: 時間ランダムオフセット (分)
- `repeat`: セッション繰り返し間隔 (分)
- `total-sessions`: 総セッション数 (-1=無限)

## filters.yml 全フィルター

### プロフィールタイプ
- `skip_if_private`: 非公開アカウントをスキップ
- `skip_if_public`: 公開アカウントをスキップ
- `skip_business`: ビジネスアカウントをスキップ (default: true)
- `skip_non_business`: 非ビジネスをスキップ
- `skip_following`: 既にフォロー中をスキップ (default: true)
- `skip_follower`: フォロワーをスキップ
- `skip_if_link_in_bio`: プロフにリンクがある場合スキップ
- `follow_private_or_empty`: 非公開/投稿なしでもフォロー

### プロフィール統計
- `min_followers` / `max_followers`: フォロワー数範囲
- `min_followings` / `max_followings`: フォロー中数範囲
- `min_potency_ratio` / `max_potency_ratio`: フォロワー/フォロー中比率
- `min_posts`: 最小投稿数
- `mutual_friends`: 共通フォロワー数 (-1=無効)

### プロフィール文フィルター
- `blacklist_words`: 禁止ワード
- `mandatory_words`: 必須ワード
- `specific_alphabet`: 許可文字種 [LATIN, GREEK, ARABIAN, etc.]
- `biography_language`: 許可言語 [it, en, ja, etc.]
- `biography_banned_language`: 禁止言語

### コメント有効化 (アクション別)
- 各インタラクションタイプに個別のコメントON/OFFフラグ
- `comment_photos/videos/carousels`: メディアタイプ別コメント許可

### DM/いいね数フィルター
- `pm_to_private_or_empty`: 非公開アカウントにDM許可
- `min_likers` / `max_likers`: 投稿のいいね数範囲

## スピンタックス (Spintax)

コメントとDMで使用可能:
- `{Hey|Hello|Hi}` → "Hey" or "Hello" or "Hi" からランダム選択
- ネスト対応: `{{s|S}pintax|spin syntax}` → "Spintax" or "spin syntax"
- エスケープ: 奇数バックスラッシュで特殊文字をエスケープ

## コメントファイル形式

```
%PHOTO
写真用コメント1
写真用コメント2
%VIDEO
動画用コメント1
%CAROUSEL
カルーセル用コメント1
```

## Telegramレポート

```yaml
# telegram.yml
telegram-api-token: 123456789:ABCDEFGHILMNOPQRSTUVZ-1AB2CD3
telegram-chat-id: -123456789
```

- @BotFather でボット作成 → APIトークン取得
- @myidbot の /getgroupid でチャットID取得
