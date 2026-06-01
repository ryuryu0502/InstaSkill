# GramAddict Bot - トラブルシューティング & 運用ノウハウ

## よくある問題と解決策

### 1. ADBデバイスが表示されない (`adb devices` が空)
**特にTermuxで頻発**
1. 電話をPCにUSB接続
2. PCで `adb devices` 確認
3. PCから `adb tcpip 5555` 実行
4. PCで `adb kill-server` → USB切断
5. Termuxで `adb connect localhost:5555`
6. 確認: `adb devices`

### 2. Termuxでボットがフリーズ / シェルが落ちる
**原因**: `close-apps` 機能がTermuxと競合
**修正**: `config.yml` で `close-apps: false` に設定 (必須)

### 3. uiautomator2がセッション再開時にクラッシュ (Issue #394)
**症状**: `UiAutomationNotConnectedError`
**対策**: `restart-atx-agent: true` を設定

### 4. Instagramが開くが何も起きない (Issue #353)
**原因**:
- atx-agentのサイレントクラッシュ
- Instagramのバージョン不一致 (UI要素IDが変更)
- UI要素セレクタの失敗
**対策**: `allow-untested-ig-version: true` + `restart-atx-agent: true`

### 5. 設定ファイルのパスにスペース (Windows)
**修正**: パスをクォートで囲む
`python run.py --config "C:\Users\Master M\Desktop\bot\config.yml"`

### 6. Python 3.10 非対応
- Python 3.6〜3.9を使用すること
- 3.10では依存パッケージの問題で動作しない

### 7. uiautomator2/minicapの初期化がハング
```bash
adb shell pkill atx-agent
pip3 install uiautomator2 --upgrade
python3 -m uiautomator2 init
```

### 8. `-32001 JsonRpc error` / `INJECT_EVENTS permission`
USBデバッグが正しく許可されていない。開発者設定で再許可する。

### 9. 画面ロックがあると `screen-sleep` が動作しない
パスコードがある場合は手動で解除が必要

### 10. アンフォローループ (Issue #430)
ブロック済みユーザーまたは処理済みユーザーでループする問題

## アカウント安全のベストプラクティス

### 推奨設定値 (安全マージン)
```yaml
# 保守的な制限
total-likes-limit: 120-150       # 300ではなく
total-follows-limit: 40-50       # 50で
total-unfollows-limit: 40-50
interactions-count: 30-40        # ソース毎
likes-count: 1-2                 # ユーザー毎
follow-percentage: 30-40         # 全員フォローしない
interact-percentage: 30-40       # スキップ多めで人間らしく

# 人間らしいスケジュール
working-hours: [10.15-16.40, 18.15-22.46]  # 昼夜2回
time-delta: 10-15                # 開始時刻をランダムに
repeat: 280-320                  # 5時間程度の間隔

# 安全トグル
shuffle-jobs: true               # ジョブ順をランダム化
truncate-sources: 2-5            # ソースも一部だけ使用
```

### スクレイピング安全パターン (2アカウント戦略)
1. サブアカウントで `scrape-to-file: scraped.txt` → 条件に合うユーザーを収集 (交流なし)
2. メインアカウントで `interact-from-file: [scraped.txt]` → 事前フィルタリング済みリストにのみ交流
- メインアカウントのリスクを最小化

### その他の注意点
- Instagramの言語は必ず**英語**に設定
- すべての数値は必ず範囲指定 (例: `120-150`) でランダム化
- `follow-percentage` は100%にしない
- 通知はオフ推奨 (ボット動作の妨げになる)
- テスト済みIGバージョン以外では予期せぬ動作の可能性

## Termux スマホ単独実行

### セットアップ手順
1. F-DroidからTermuxをインストール
2. `pkg update && pkg install android-tools python build-essential cmake libjpeg-turbo libpng libxml2 libxslt freetype git`
3. `pip install wheel`
4. `git clone https://github.com/GramAddict/bot.git && cd bot`
5. `pip install -r requirements.txt`
6. ADB設定: PCで一度 `adb tcpip 5555` → Termuxで `adb connect localhost:5555`
7. `python -m uiautomator2 init`
8. `config-examples/` から `accounts/<username>/` に設定ファイルをコピー・編集
9. **重要**: `close-apps: false` を設定
10. FX File ExplorerでTermuxファイルを編集
11. `python run.py --config accounts/<username>/config.yml`

## Discord コミュニティ

- Discord: discord.gg/9MTjgs8g5R
- チャンネル: #general, #community-support, #botting-on-termux, #development, #lobby
- 質問はDiscordで（GitHub Issuesはバグ報告用）

## プロジェクト健全性

- 最終リリース: 2024年3月 (v3.2.12)
- Issue #439 で「死んだプロジェクトか」と質問あり (2025年7月)
- 79件のIssue、メンテナンスペースに懸念
