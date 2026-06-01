"""GramAddict 簡易シミュレータ - テスト用"""

import os
import sys
import time
import json
import traceback
from pathlib import Path

class BotRunner:
    def __init__(self, config_path):
        self.config_path = config_path
        self.session = {"likes": 0, "follows": 0, "unfollows": 0}
        self.running = False
        self.config = self.load_config()

    def load_config(self):
        if not os.path.exists(self.config_path):
            return {}
        try:
            with open(self.config_path, encoding="utf-8") as f:
                return json.load(f)
        except (json.JSONDecodeError, UnicodeDecodeError, OSError) as e:
            print(f"FATAL: Failed to load config: {e}")
            sys.exit(1)

    def start(self):
        self.running = True
        print("Bot started")
        error_count = 0
        max_errors = 5
        while self.running:
            try:
                self.process_interactions()
                error_count = 0
            except Exception as e:
                error_count += 1
                print(f"Error ({error_count}/{max_errors}): {e}")
                if error_count >= max_errors:
                    print("FATAL: Too many errors, shutting down")
                    self.running = False
                    break
                time.sleep(5 * error_count)
                continue

    def stop(self):
        self.running = False

    def process_interactions(self):
        # ハッシュタグ処理
        hashtags = self.config.get("hashtags", ["travel", "food"])
        for tag in hashtags:
            self.like_hashtag_posts(tag)
            if not self.running:
                break
            self.follow_users(tag)
        # メインループのCPUスピンを防止
        time.sleep(60)

    def like_hashtag_posts(self, tag):
        print(f"Liking posts for #{tag}")
        likes = self.config.get("likes_per_tag", 5)
        if not isinstance(likes, int) or likes < 0:
            print(f"WARNING: Invalid likes_per_tag value: {likes}, using default 5")
            likes = 5
        for i in range(likes):
            if not self.running:
                break
            # いいね処理
            time.sleep(0.5)
            self.session["likes"] += 1
            # ここで実際のいいねAPIを呼ぶ想定

    def follow_users(self, tag):
        print(f"Following users for #{tag}")
        follows = self.config.get("follows_per_tag", 3)
        if not isinstance(follows, int) or follows < 0:
            print(f"WARNING: Invalid follows_per_tag value: {follows}, using default 3")
            follows = 3
        for i in range(follows):
            if not self.running:
                break
            # フォロー処理
            time.sleep(1)
            self.session["follows"] += 1

    def get_stats(self):
        return dict(self.session)


class ConfigValidator:
    @staticmethod
    def validate(config):
        errors = []
        if not config:
            errors.append("Config is empty")
            return errors

        if "hashtags" not in config:
            errors.append("hashtags is required")

        likes = config.get("likes_per_tag", 0)
        if likes > 100:
            errors.append("likes_per_tag is too high (>100)")

        return errors


def main():
    # 設定ファイルパスの処理
    config_path = sys.argv[1] if len(sys.argv) > 1 else "config.json"
    if config_path == "":
        print("ERROR: config path is empty string")
        sys.exit(1)

    # 設定の読み込みと検証
    config = {}
    if os.path.exists(config_path):
        try:
            with open(config_path, encoding="utf-8") as f:
                config = json.load(f)
        except (json.JSONDecodeError, UnicodeDecodeError, OSError) as e:
            print(f"FATAL: Failed to read config file: {e}")
            sys.exit(1)

        errors = ConfigValidator.validate(config)
        if errors:
            for err in errors:
                print(f"Validation error: {err}")
            sys.exit(1)
    else:
        print("Config not found, using defaults")

    # ボット実行（設定を直接渡して二重読み込みを防止）
    bot = BotRunner(config_path)
    bot.config = config  # 既に読み込んだ設定を注入
    try:
        bot.start()
    except KeyboardInterrupt:
        print("Shutting down...")
    finally:
        bot.stop()
        stats = bot.get_stats()
        print(f"Session stats: {stats}")

        # 統計の保存（ミリ秒精度で上書き防止）
        output_dir = Path("output")
        output_dir.mkdir(exist_ok=True)
        timestamp = time.time_ns() // 1_000_000  # ミリ秒精度
        report_file = output_dir / f"report_{timestamp}.json"
        with open(report_file, "w", encoding="utf-8") as f:
            json.dump(stats, f, ensure_ascii=False, indent=2)
        print(f"Report saved: {report_file}")


if __name__ == "__main__":
    main()
