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
echo "📋 起動後の手順:"
echo "  1. リーダーエージェント指示書が自動で読み込まれます"
echo "  2. 全体ワークフロー（04_multi_agent_operational_workflow.md）が自動で読み込まれます"
echo "  3. ユーザーが @workflow_phase_1_requirements_design.md を読み込ませてPhase 1を開始"
echo ""

# Claude Codeを起動してリーダーエージェント指示書と全体ワークフローのみ自動で読み込む
claude -c "cat .ai-framework/templates/leader_agent_setup_template.md && echo '' && echo '📚 全体ワークフローを読み込みます...' && cat .ai-framework/templates/04_multi_agent_operational_workflow.md"

echo ""
echo "Phase 1-2の作業が完了しました"
echo ""
echo "次のステップ:"
echo "1. Phase 1を開始: @workflow_phase_1_requirements_design.md を読み込ませてください"
echo "2. Phase 2へ移行: Phase 1完了後、@workflow_phase_2_task_breakdown.md を読み込ませてください"
echo "3. Phase 3へ移行: Phase 2完了後、./scripts/phase3-start.sh を実行してください"