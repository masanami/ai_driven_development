#!/bin/bash
set -euo pipefail

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Phase 1-2: リーダーエージェントのみ起動（tmux不使用）"
echo ""

# 前提条件チェック
echo "📋 前提条件をチェック中..."

# Claudeコマンドがあるかチェック
if ! command -v claude &> /dev/null; then
    echo "❌ claudeコマンドが見つかりません"
    echo "   Claude Codeがインストールされていることを確認してください"
    exit 1
fi

echo "✅ claude: 利用可能"
echo ""

# Phase 1-2用のリーダーエージェント起動
echo "👑 Phase 1-2: リーダーエージェントを起動します..."
echo ""
echo "📋 実行手順:"
echo "1. claudeコマンドでClaude Codeを起動"
echo "2. リーダーエージェントの指示書を読み込み"
echo "3. auto-accept機能を有効化"
echo ""
echo "🎯 Phase 1（要件定義・基本設計）を開始してください"
echo ""
echo "💡 ヒント:"
echo "  - Phase 1: 要件定義・基本設計はリーダーエージェントのみで実行"
echo "  - Phase 2: タスク分割・GitHub Issues作成もリーダーエージェントのみで実行"
echo "  - Phase 3開始時に初めてtmuxで複数エージェントを起動します"
echo ""
echo "📋 Claude Codeで実行するコマンド:"
echo "  cat .ai-framework/templates/leader_agent_setup_template.md"
echo ""

# Claude Codeを起動
claude

echo ""
echo "✅ Phase 1-2の作業が完了しました"
echo ""
echo "🎯 次のステップ:"
echo "Phase 3（並列実装）を開始する場合は、以下のコマンドを実行してください:"
echo "  ./scripts/phase3-start.sh"