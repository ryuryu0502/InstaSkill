# GramAddict Bot - コアエンジン詳細

## セッション状態管理 (SessionState)

### JSONシリアライズ形式
```json
{
    "id": "uuid-string",
    "total_interactions": 1234,
    "successful_interactions": 567,
    "total_followed": 89,
    "total_likes": 300,
    "total_comments": 10,
    "total_pm": 5,
    "total_watched": 50,
    "total_unfollowed": 40,
    "total_scraped": 200,
    "start_time": "2026-06-01 14:30:00.123456",
    "finish_time": "2026-06-01 23:59:59.654321",
    "args": { /* 全設定キー */ },
    "profile": { "posts": 150, "followers": 1200, "following": 300 }
}
```

### 制限チェック (check_limit)
`Limit.ALL` を指定すると3タプルを返す:
```
(
    (likes_reached AND end_if_likes_limit_reached) OR ... ,
    unfollow_limit_reached,
    total_interactions_reached OR total_successful_reached OR total_scraped_reached
)
```
- 第1要素: 個別操作が終了フラグ付きで制限到達 → セッション全体を停止
- 第2要素: アンフォローのみ制限到達 → アンフォロージョブのみスキップ
- 第3要素: 総数系が制限到達 → 全activeジョブ停止

## Android Resource ID マッピング

`ResourceID(APP_ID)` で `com.instagram.android:id/{element}` 形式のIDを生成。103個のUI要素IDを定義。

### 主なカテゴリ
| カテゴリ | 個数 | 主な要素 |
|---------|------|---------|
| アクションバー | 12 | 戻る、タイトル、検索、オーバーフロー |
| プロフィール | 30 | 自己紹介、フォロワー数、アバター、タブ |
| フィード・投稿 | 15 | いいね、コメント、CTA、写真名 |
| カルーセル/メディア | 7 | メディアグループ、画像、動画 |
| リール/動画 | 9 | クリップス、リールビューア、IG Live |
| 検索 | 4 | 検索テキスト、検索結果 |
| フォローリスト | 7 | コンテナ、ユーザー名、アンフォロー行 |
| ダイアログ | 5 | ルート、コンテナ、ボタン |
| その他 | ~14 | タブバー、リサイクラービュー、ライブバッジ |

### 複合セレクタ (|区切りOR条件)
```python
MEDIA_CONTAINER = "zoomable|carousel_media_group|sponsored|collection_root|media_content_location"
USER_LIST_CONTAINER = "follow_list_container|row_user_container_base|recommended_user_row_content_identifier"
BLOCK_POPUP = "dialog_container|dialog_root_view"
CRASH_POPUP = "android:id/aerr_restart|android:id/aerr_close"
```
InstagramのA/Bテストや異なるUIバージョンに対応するための設計。

## 画面ナビゲーション (navigation.py)

| 関数 | 責務 |
|------|------|
| `check_if_english(device)` | Posts/Followers/Followingラベルで英語判定。不一致時はsys.exit(1) |
| `nav_to_blogger(device, username, job)` | ブロガーのフォロワー/フォロー中一覧へ遷移 |
| `nav_to_hashtag_or_place(device, target, job)` | ハッシュタグ/場所/フィードへ遷移 |
| `nav_to_post_likers(device, username, my_username)` | 投稿のいいね一覧へ遷移 |
| `nav_to_feed(device)` | ホームフィードへ遷移 |

## スクロール終了検出 (ScrollEndDetector)

### アルゴリズム
同一のユーザー名リストが `repeats_to_end` 回（デフォルト5回）連続して出現 → リスト終端と判定。

### 二重のスキップ制限
- `skipped_all`: 累積カウンタ。`skipped_list_limit` で閾値チェック
- `skipped_all_fling`: 累積カウンタ。`skipped_fling_limit` に達したらフリング実行し自動リセット

## TabBarText 定数
```python
HOME_CONTENT_DESC = "Home"
SEARCH_CONTENT_DESC = "Search and Explore"
PROFILE_CONTENT_DESC = "Profile"
REELS_CONTENT_DESC = "Reels"
ACTIVITY_CONTENT_DESC = "Activity"
```

## ClassName 定数 (Androidウィジェット)
```python
BUTTON = "android.widget.Button"
TEXT_VIEW = "android.widget.TextView"
EDIT_TEXT = "android.widget.EditText"
IMAGE_VIEW = "android.widget.ImageView"
RECYCLER_VIEW = "androidx.recyclerview.widget.RecyclerView"
LIST_VIEW = "android.widget.ListView"
VIEW_PAGER = "androidx.viewpager.widget.ViewPager"
```
