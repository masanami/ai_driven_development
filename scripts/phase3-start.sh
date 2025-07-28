#!/bin/bash
set -euo pipefail

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# AI Framework の基本パス
BASE_PATH="$SCRIPT_DIR/.."

echo "🚀 Phase 3: 並列実装フェーズ - tmuxマルチエージェント起動"
echo ""

# 前提条件チェック
echo "📋 前提条件をチェック中..."

# tmuxがインストールされているかチェック
if ! command -v tmux &> /dev/null; then
    echo "❌ tmuxがインストールされていません"
    echo "   macOS: brew install tmux"
    echo "   Ubuntu: sudo apt-get install tmux"
    exit 1
fi

echo "✅ tmux: インストール済み"

# Claudeコマンドがあるかチェック
if ! command -v claude &> /dev/null; then
    echo "⚠️  claudeコマンドが見つかりません"
    echo "   Claude Codeがインストールされていることを確認してください"
    echo "   または、各ペインで手動でClaude Codeを起動してください"
else
    echo "✅ claude: 利用可能"
fi

echo ""
echo "📋 Phase 1-2の完了確認"
echo "✅ 要件定義・基本設計完了"
echo "✅ タスク分割・GitHub Issues作成完了"
echo ""

read -p "Phase 3の並列実装を開始しますか？ (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Phase 3の開始をキャンセルしました"
    exit 0
fi

echo ""
echo "🔧 Phase 3用のtmux環境を構築中..."

# 既存のagentsセッションがある場合は削除
if tmux has-session -t agents 2>/dev/null; then
    echo "⚠️  既存のagentsセッションを削除中..."
    tmux kill-session -t agents
    sleep 1
fi

# tmux環境セットアップ
"${SCRIPT_DIR}/setup-agent-communication.sh"

if [ $? -ne 0 ]; then
    echo "❌ 環境構築に失敗しました"
    exit 1
fi

echo ""
echo "⏳ 5秒待機中..."
sleep 5

# エージェント起動（4分割）
echo "📊 マルチエージェント起動中..."
"${SCRIPT_DIR}/start-agents.sh"

if [ $? -ne 0 ]; then
    echo "❌ エージェント起動に失敗しました"
    exit 1
fi

echo ""
echo "✅ Phase 3の準備が完了しました！"
echo ""
echo "🎯 次のステップ:"
echo "1. tmux attach-session -t agents でセッションに接続"
echo "2. LEADERペインで以下のファイルを読み込ませてください:"
echo "   - @${BASE_PATH}/workflow_phase_3_parallel_implementation.md"
echo "   - @${BASE_PATH}/05_practical_agent_communication_system.md"
echo "3. LEADERペインでタスク分配を開始"
echo "4. 各エンジニアエージェントが並列実装を実行"
echo ""
echo "💡 重要な操作:"
echo "  - ペイン切り替え: Ctrl+b → 矢印キー"
echo "  - セッション離脱: Ctrl+b → d"
echo "  - セッション再接続: tmux attach-session -t agents"
echo ""

read -p "tmuxセッションに接続しますか？ (Y/n): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    echo "📺 agentsセッションに接続します..."
    tmux attach-session -t agents
else
    echo "🔧 手動で接続する場合:"
    echo "   tmux attach-session -t agents"
fi