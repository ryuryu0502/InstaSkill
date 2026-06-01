# GramAddict Bot - プラグインアーキテクチャ詳細

## プラグイン基底クラス (Plugin)

```python
class Plugin:
    description = ""
    arguments = []
    action = False

    def run(self, device, configs, storage, sessions, profile_filter, plugin):
        raise NotImplementedError
```

全プラグインがこの基底クラスを継承。プラグインは `GramAddict/plugins/` に `.py` ファイルを置くだけで自動検出される。

## 全15プラグイン一覧

| プラグイン | クラス名 | 主な操作 |
|-----------|---------|---------|
| interact_hashtag_posts | InteractHashtagPosts | ハッシュタグ投稿者と交流 |
| interact_hashtag_likers | InteractHashtagLikers | ハッシュタグ投稿のいいねユーザー |
| interact_place_posts | InteractPlacePosts | 場所投稿者と交流 |
| interact_place_likers | InteractPlaceLikers | 場所投稿のいいねユーザー |
| interact_blogger | InteractBlogger | 特定ユーザーと直接交流 |
| interact_blogger_followers | InteractBloggerFollowers_Following | ブロガーのフォロワーと交流 |
| interact_blogger_post_likers | InteractBloggerPostLikers | ブロガー投稿のいいねユーザー |
| interact_feed | InteractOwnFeed | 自分のフィードと交流 |
| like_from_urls | LikeFromURLs | URLから投稿にいいね |
| action_unfollow_followers | ActionUnfollowFollowers | 5種類のアンフォロー操作 |
| remove_followers | RemoveFollowers | フォロワー除去 |
| telegram | TelegramReports | Telegramレポート送信 |
| data_analytics | DataAnalytics | 分析レポート（非推奨） |
| cloned_app | ClonedApp | クローンアプリ対応 |
| core_arguments | (なし) | 全62の共有CLI引数を登録 |

## 全プラグイン共通パターン

### 1. 動的 State クラス
```python
class State:
    is_job_completed = False
```
`run()` メソッド内で動的に定義され、ジョブ完了フラグを管理。

### 2. @run_safely デコレータ
```python
@run_safely(device=device, device_id=..., sessions=..., session_state=..., screen_record=..., configs=configs)
def job():
    self.handle_xxx(...)
    self.state.is_job_completed = True

while not self.state.is_job_completed and not limit_reached:
    job()
```
例外発生時に自動リトライ。クラッシュレポート自動保存。

### 3. functools.partial による依存性注入
```python
interaction = partial(interact_with_user, my_username=..., likes_count=..., ...)
is_follow_limit_reached = partial(is_follow_limit_reached_for_source, ...)
```
コア処理関数に設定を注入するパターン。

### 4. sample_sources() によるランダム化
```python
for source in sample_sources(sources, self.args.truncate_sources):
```
ソースをシャッフルし、`truncate_sources` で指定数に切り詰め。

### 5. セッション制限チェック
```python
(active_limits_reached, _, actions_limit_reached) = self.session_state.check_limit(Limit.ALL)
limit_reached = active_limits_reached or actions_limit_reached
```

## プラグイン別アーキテクチャ比較

| 特徴 | HashtagPosts | BloggerFollowers | Unfollow | Feed | Telegram |
|------|-------------|-----------------|----------|------|----------|
| ソースループ | あり(ハッシュタグ) | あり(ブロガー) | あり(自分のフォロー) | なし | N/A |
| handle_*委譲先 | handle_posts | handle_followers | iterate_over_followings | handle_posts | N/A |
| ScrollEndDetector | あり | あり | あり | あり | なし |
| ResourceID使用 | なし | あり | あり | なし | なし |
| フォロー制限 | あり | あり | N/A | None | N/A |
| run()引数 | 6引数標準 | 6引数標準 | 6引数標準 | 6引数標準 | 4引数(独自) |

## UnfollowRestriction Enum（アンフォロー戦略）

```python
class UnfollowRestriction(Enum):
    ANY = 0                    # unfollow-any
    FOLLOWED_BY_SCRIPT = 1     # unfollow (ボット経由)
    FOLLOWED_BY_SCRIPT_NON_FOLLOWERS = 2  # unfollow-non-followers
    ANY_NON_FOLLOWERS = 3      # unfollow-any-non-followers
    ANY_FOLLOWERS = 4          # unfollow-any-followers
```

## Telegramレポートの集計ロジック

- `accounts/{username}/sessions.json` から全セッション履歴を読み込み
- `start_time[:10]` で日付グループ化
- 各日付のアクション数を合計
- 7日間平均を計算
- Markdown形式で整形しBot API経由で送信
