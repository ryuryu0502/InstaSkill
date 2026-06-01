#!/bin/bash
# ============================================================
# Claude Code セッション再開・権限初期化スクリプト
# 使用方法: bash .claude/init_session.sh
#
# このスクリプトは、別のAIインスタンスがこのプロジェクトを
# 引き継ぐ際に必要な設定を自動的にセットアップします。
# ============================================================

set -e

echo "============================================"
echo " Claude Code セッション初期化"
echo "============================================"
echo ""

# === 1. プロジェクト状態確認 ===
echo "📁 1. プロジェクト状態確認"
echo "-------------------------"
git status 2>/dev/null | head -3
echo ""
git log --oneline -3 2>/dev/null
echo ""

# === 2. 未解決Issue確認 ===
echo "📋 2. 未解決Issue一覧"
echo "----------------------"
if ls .github/ISSUES/*.md 1>/dev/null 2>&1; then
    for f in .github/ISSUES/*.md; do
        NAME=$(basename "$f" .md)
        FIRST_LINE=$(head -1 "$f" 2>/dev/null | sed 's/^# //')
        echo "   - $NAME: $FIRST_LINE"
    done
else
    echo "   ⚠️  .github/ISSUES/ が見つからないか空です"
fi
echo ""

# === 3. 権限設定確認 ===
echo "🔒 3. 権限設定確認"
echo "--------------------"
if [ -f .claude/settings.local.json ]; then
    echo "   設定ファイル: .claude/settings.local.json"
    echo "   Allow ルール数: $(grep -c '"Bash\|Read\|Web\|Skill\|Workflow' .claude/settings.local.json 2>/dev/null || echo 0)"
else
    echo "   ⚠️  .claude/settings.local.json が見つかりません"
fi
echo ""

# === 4. 最新の作業内容確認 ===
echo "📝 4. 最新の作業内容"
echo "----------------------"
if ls Work/ 1>/dev/null 2>&1; then
    echo "   調査レポート一覧:"
    for f in Work/*.md; do
        SIZE=$(wc -c < "$f" 2>/dev/null)
        echo "   - $f ($SIZE bytes)"
    done
else
    echo "   Work/ ディレクトリがありません"
fi
echo ""

# === 5. スキル一覧 ===
echo "🎯 5. 使用可能なカスタムスキル"
echo "-------------------------------"
if [ -d .claude/skills/gramaddict ]; then
    echo "   ✅ gramaddict - Instagram自動化ボットスキル"
    if [ -f .claude/skills/gramaddict/SKILL.md ]; then
        VERSION=$(grep "最新バージョン" .claude/skills/gramaddict/SKILL.md | head -1)
        echo "      $VERSION"
    fi
else
    echo "   ⚠️  カスタムスキルが見つかりません"
fi
echo ""

# === 6. 推奨コマンド ===
echo "💡 6. 推奨次のアクション"
echo "-------------------------"
echo "   1. 各 Issue を確認: cat .github/ISSUES/*.md"
echo "   2. 未完了タスクを確認: grep '\[ \]' .github/ISSUES/*.md"
echo "   3. 調査レポートを読む: cat Work/skill-test-report.md"
echo ""
echo "============================================"
echo " 初期化完了"
echo "============================================"
