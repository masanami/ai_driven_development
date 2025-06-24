#!/bin/bash
set -euo pipefail

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🤖 直接通信型エージェント起動中..."

# agentsセッションの存在確認
if ! tmux has-session -t agents 2>/dev/null; then
    echo "❌ エラー: 'agents' tmuxセッションが見つかりません"
    echo "📋 解決方法:"
    echo "  1. セットアップスクリプトを実行してください:"
    echo "     ./scripts/setup-agent-communication.sh"
    echo "  2. または手動でセッションを作成してください:"
    echo "     tmux new-session -d -s agents"
    exit 1
fi

echo "✅ agentsセッション確認完了"

# 全エージェント一括起動・指示書読み込み
echo "🤖 全エージェント一括起動中..."

# LEADER (pane 0)
echo "👑 LEADER起動中..."
tmux send-keys -t agents:0.0 'claude'
tmux send-keys -t agents:0.0 C-m
sleep 3
tmux send-keys -t agents:0.0 "cat '${SCRIPT_DIR}/../templates/leader_agent_setup_template.md'"
tmux send-keys -t agents:0.0 C-m
sleep 2
echo "  🔧 LEADER auto-accept有効化中..."
tmux send-keys -t agents:0.0 C-space
tmux send-keys -t agents:0.0 'auto-accept edits on'
tmux send-keys -t agents:0.0 C-m

# engineer-1 (pane 1)
echo "💻 engineer-1起動中..."
tmux send-keys -t agents:0.1 'claude'
tmux send-keys -t agents:0.1 C-m
sleep 3
tmux send-keys -t agents:0.1 "cat '${SCRIPT_DIR}/../templates/engineer_agent_setup_template.md'"
tmux send-keys -t agents:0.1 C-m
sleep 2
echo "  🔧 engineer-1 auto-accept有効化中..."
tmux send-keys -t agents:0.1 C-space
tmux send-keys -t agents:0.1 'auto-accept edits on'
tmux send-keys -t agents:0.1 C-m

# engineer-2 (pane 2)
echo "🖥️ engineer-2起動中..."
tmux send-keys -t agents:0.2 'claude'
tmux send-keys -t agents:0.2 C-m
sleep 3
tmux send-keys -t agents:0.2 "cat '${SCRIPT_DIR}/../templates/engineer_agent_setup_template.md'"
tmux send-keys -t agents:0.2 C-m
sleep 2
echo "  🔧 engineer-2 auto-accept有効化中..."
tmux send-keys -t agents:0.2 C-space
tmux send-keys -t agents:0.2 'auto-accept edits on'
tmux send-keys -t agents:0.2 C-m

# engineer-3 (pane 3)
echo "⚙️ engineer-3起動中..."
tmux send-keys -t agents:0.3 'claude'
tmux send-keys -t agents:0.3 C-m
sleep 3
tmux send-keys -t agents:0.3 "cat '${SCRIPT_DIR}/../templates/engineer_agent_setup_template.md'"
tmux send-keys -t agents:0.3 C-m
sleep 2
echo "  🔧 engineer-3 auto-accept有効化中..."
tmux send-keys -t agents:0.3 C-space
tmux send-keys -t agents:0.3 'auto-accept edits on'
tmux send-keys -t agents:0.3 C-m

# qa-agent (pane 4)
echo "🧪 qa-agent起動中..."
tmux send-keys -t agents:0.4 'claude'
tmux send-keys -t agents:0.4 C-m
sleep 3
tmux send-keys -t agents:0.4 "cat '${SCRIPT_DIR}/../templates/qa_agent_setup_template.md'"
tmux send-keys -t agents:0.4 C-m
sleep 2
echo "  🔧 qa-agent auto-accept有効化中..."
tmux send-keys -t agents:0.4 C-space
tmux send-keys -t agents:0.4 'auto-accept edits on'
tmux send-keys -t agents:0.4 C-m

# LEADERペインをアクティブに設定
echo "🎯 LEADERペインをアクティブに設定中..."
tmux select-pane -t agents:0.0

echo "✅ 全エージェント起動完了！"
echo "🔧 auto-accept機能が全エージェントで有効化されました"
echo ""
echo "🎯 次のステップ:"
echo "1. agentsセッションのLEADERペインに指示を出してください。"
echo "2. 自動的にエージェント間の直接通信が開始されます"
echo ""
echo "📊 セッション確認:"
echo "  tmux attach-session -t agents" 