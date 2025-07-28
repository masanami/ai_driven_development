#!/bin/bash
set -euo pipefail

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# AI Framework の基本パス
BASE_PATH="$SCRIPT_DIR/.."

echo "🚀 Phase 2: タスク分割・タスクリスト作成フェーズ - リーダーエージェント継続"
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

# Phase 1完了確認
echo "📋 Phase 1完了確認"
echo "✅ 要件定義・基本設計完了（想定）"
echo ""

read -p "Phase 1は完了していますか？ (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Phase 2の開始をキャンセルしました"
    echo "   Phase 1を完了してから再度実行してください"
    echo "   ./scripts/phase1-start.sh"
    exit 0
fi

echo ""

# Phase 2用のリーダーエージェント起動
echo "👑 Phase 2: リーダーエージェントを起動します..."
echo ""
echo "📋 実行内容:"
echo "1. Phase 2ワークフロー（workflow_phase_2_task_breakdown.md）の読み込み"
echo "2. タスク分割の実行"
echo "3. タスクリストファイル（.ai/tasks/task_list.md）の作成"
echo "4. 個別タスクファイル（.ai/tasks/task_XXX.md）の作成"
echo ""
echo "🎯 Phase 2の内容:"
echo "  - 基本設計を実装可能なタスクに分割"
echo "  - タスク間の依存関係を分析"
echo "  - 並列実行可能なタスクを特定"
echo "  - タスクリストファイルと個別タスクファイルを作成"
echo ""
echo "⚠️  注意: Phase 2では実装は行いません（タスク分割のみ）"
echo ""

# Claude Codeを起動してPhase 2ワークフローを自動で読み込む
claude -c "echo '📋 Phase 2ワークフローを読み込みます...' && cat ${BASE_PATH}/workflow_phase_2_task_breakdown.md"

echo ""
echo "✅ Phase 2の準備が完了しました"
echo ""
echo "🎯 次のステップ:"
echo "Phase 2完了後、Phase 3（並列実装）へ移行する場合は以下のコマンドを実行してください:"
echo "  ./scripts/phase3-start.sh"