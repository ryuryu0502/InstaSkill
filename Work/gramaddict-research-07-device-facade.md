# GramAddict Bot - デバイス抽象化層と詳細実装

## DeviceFacade (device_facade.py)

### デバイス接続分岐
- `device_id` が `None` または `.` を含まない → USB接続 (`uiautomator2.connect`)
- `device_id` に `.` が含まれる → ADB-over-WiFi接続 (`uiautomator2.connect_adb_wifi`)
- ※IPアドレス形式(例: 192.168.1.5)のドット検出で判定

### 5つのEnum
```python
Timeout: ZERO, TINY, SHORT, MEDIUM, LONG
SleepTime: ZERO, TINY, SHORT, DEFAULT
Location: CUSTOM, WHOLE, CENTER, BOTTOM, RIGHT, LEFT, BOTTOMRIGHT, LEFTEDGE, RIGHTEDGE, TOPLEFT
Direction: UP, DOWN, RIGHT, LEFT
Mode: TYPE, PASTE
```

### DeviceFacade.View 内部クラス (24メソッド)
| メソッド | 説明 |
|---------|------|
| click() | 位置オフセット方式クリック。Location enumに応じて要素内のランダム座標を計算。WHOLE:15-85%, CENTER:40-60%, LEFTEDGE:10-20% X 40-60% Y など |
| click_retry() | クリック後要素が消えるまで最大リトライ(2-4秒待機) |
| double_click() | パディング内ランダム座標でダブルクリック。間隔50-140msランダム |
| exists() | uiautomator2既知バグ対応: exists()がFalseでもcount>=1ならバグ扱い |
| set_text() | 人間らしいタイピング: 最初の1-3文字を1文字ずつ、残りを一括送信、文末句読点を個別処理 |
| scroll()/fling() | UP/DOWN方向のスクロール/フリング |
| child/sibling/left/right/up/down() | 相対ナビゲーション、結果をViewでラップ |

### 画面録画のリングバッファ (モンキーパッチ)
`uiautomator2.screenrecord.Screenrecord` の `_run` と `stop` を実行時に動的置き換え。
- `deque(maxlen=fps*30)` によるリングバッファ（最大600フレーム）
- クラッシュ時のみ直近30秒間のフレームを動画ファイルに出力
- 常時録画によるストレージ消費を回避しつつデバッグ情報を確保

### 既知のバグ
- `window_size()`: `self.deviceV2.window_size()`の戻り値をreturnしていない

## handle_sources.py - ソース処理

### 主要ハンドラ
| 関数 | 責務 |
|------|------|
| interact() | 全インタラクションの単一エントリポイント |
| handle_blogger() | ブロガーへのナビゲーションと交流 |
| handle_blogger_from_file() | ファイル駆動ユーザーリスト処理 |
| handle_followers() | フォロワー一覧のスクロール取得 |
| handle_likers() | いいね一覧のスクロール取得 |
| handle_posts() | フィード/ハッシュタグ/場所の投稿一覧処理 |

### スクロール取得の重要ロジック
- **重複投稿検出**: post_descriptionで同一投稿を3回連続検出で終了
- **行高さフィルタリング**: `inspect_current_view()` でrow_height取得、小さい項目はスキップ
- **ユーザー名抽出パス**: `item.child(index=1).child(index=0).child()`
- **広告/ハッシュタグ/既いいね検出**: 各投稿で判定

## views.py - UIビュー抽象化

### Viewクラス一覧 (18クラス)
| クラス | 役割 |
|--------|------|
| TabBarView | ボトムタブバーナビゲーション |
| ActionBarView | アクションバー基底 |
| HomeView/HashTagView/PlacesView | 各コンテンツブラウジング |
| SearchView | 検索UI+タブナビゲーション |
| PostsViewList | フィード/投稿リスト操作 |
| OpenedPostView | 単一投稿表示 |
| PostsGridView | プロフィールグリッド |
| ProfileView | プロフィールページ |
| FollowingView/FollowersView | フォロー/フォロワー一覧 |
| CurrentStoryView | ストーリービューア |
| UniversalActions | スワイプ、バック、ブロック検出、キーボード操作 |

### Enum
```python
TabBarTabs: HOME, SEARCH, REELS, ORDERS, ACTIVITY, PROFILE
SearchTabs: TOP, ACCOUNTS, TAGS, PLACES
FollowStatus: FOLLOW, FOLLOWING, FOLLOW_BACK, REQUESTED, NONE
SwipeTo: HALF_PHOTO, NEXT_POST
LikeMode: SINGLE_CLICK, DOUBLE_CLICK
MediaType: PHOTO, VIDEO, REEL, IGTV, CAROUSEL, UNKNOWN
```

## テスト構造

```
test/
├── mock_data/sessions.json   # 7セッションのモックデータ
├── txt/
│   ├── txt_empty.txt         # 空ファイルテスト用
│   └── txt_ok.txt            # テンプレート文言テスト用
├── test_load_txt.py          # テキストファイル読み込みテスト (3テスト)
└── test_telegram.py          # Telegramレポートテスト (7テスト)
```
