#!/bin/bash
set -euo pipefail

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# AI Framework の基本パス
BASE_PATH="$SCRIPT_DIR/.."

echo "🚀 Phase 1: 要件定義・基本設計フェーズ - リーダーエージェント起動"
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

# Phase 1用のリーダーエージェント起動
echo "👑 Phase 1: リーダーエージェントを起動します..."
echo ""
echo "📋 実行内容:"
echo "1. リーダーエージェント指示書の読み込み"
echo "2. 全体ワークフロー（04_multi_agent_operational_workflow.md）の読み込み"
echo "3. Phase 1ワークフロー（workflow_phase_1_requirements_design.md）の読み込み"
echo "4. 知識ベースアーキテクチャ（03_knowledge_base_architecture.md）の読み込み"
echo "5. auto-accept機能の有効化"
echo ""
echo "🎯 Phase 1の内容:"
echo "  - プロジェクト状況確認・要求整理"
echo "  - 要件定義書の作成"
echo "  - 基本設計・テスト戦略策定"
echo "  - ユーザー承認済み基本設計書の作成"
echo ""

# Claude Codeを起動して必要なファイルを自動で読み込む
claude -c "cat ${BASE_PATH}/templates/leader_agent_setup_template.md && \
    echo '' && \
    echo '📚 全体ワークフローを読み込みます...' && \
    cat ${BASE_PATH}/04_multi_agent_operational_workflow.md && \
    echo '' && \
    echo '📋 Phase 1ワークフローを読み込みます...' && \
    cat ${BASE_PATH}/workflow_phase_1_requirements_design.md && \
    echo '' && \
    echo '🧠 知識ベースアーキテクチャを読み込みます...' && \
    cat ${BASE_PATH}/03_knowledge_base_architecture.md"

echo ""
echo "✅ Phase 1の準備が完了しました"
echo ""
echo "🎯 次のステップ:"
echo "Phase 1完了後、Phase 2へ移行する場合は以下のコマンドを実行してください:"
echo "  ./scripts/phase2-start.sh"