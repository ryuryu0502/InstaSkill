#!/bin/bash
# ============================================================
# GramAddict バージョン確認スクリプト
# 使用方法: bash .claude/skills/gramaddict/scripts/check_version.sh
# ============================================================

set -e

echo "=== GramAddict バージョン確認 ==="
echo ""

# pip インストール版の確認
if command -v gramaddict &> /dev/null; then
    INSTALLED_VERSION=$(gramaddict --version 2>/dev/null || echo "unknown")
    echo "📦 インストール版: $INSTALLED_VERSION"
else
    echo "⚠️  gramaddict がインストールされていません"
    echo "   インストール: pip3 install gramaddict"
fi

echo ""

# pip で確認
if command -v pip3 &> /dev/null; then
    PIP_VERSION=$(pip3 show gramaddict 2>/dev/null | grep Version | cut -d' ' -f2 || echo "not found")
    echo "📋 pip 登録バージョン: $PIP_VERSION"
fi

echo ""

# GitHub 最新リリースの確認
echo "🌐 GitHub 最新リリースを確認中..."
LATEST=$(curl -s https://api.github.com/repos/GramAddict/bot/releases/latest 2>/dev/null | \
         grep '"tag_name"' | cut -d'"' -f4 || echo "不明")
echo "   最新リリース: $LATEST"

echo ""

# Python バージョンチェック
PYTHON_VERSION=$(python3 --version 2>/dev/null | cut -d' ' -f2 || echo "N/A")
echo "🐍 Python バージョン: $PYTHON_VERSION"
if [[ $(echo "$PYTHON_VERSION" | cut -d'.' -f1) -eq 3 ]] && [[ $(echo "$PYTHON_VERSION" | cut -d'.' -f2) -ge 10 ]]; then
    echo "   ⚠️  Python 3.10+ は GramAddict 非対応です（uiautomator2 問題）"
    echo "      推奨: Python 3.6〜3.9"
fi

echo ""
echo "=== SKILL.md 更新が必要な項目 ==="
echo "- 最新バージョン番号（現在: 3.2.12）"
echo "- テスト済み Instagram バージョン"
echo "- 非互換情報"
