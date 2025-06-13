#!/bin/bash

echo "🤖 直接通信型エージェント起動中..."

# 全エージェント一括起動・指示書読み込み
echo "🤖 全エージェント一括起動中..."

# LEADER (pane 0)
echo "👑 LEADER起動中..."
tmux send-keys -t agents:0.0 'claude'
tmux send-keys -t agents:0.0 C-m
sleep 3
tmux send-keys -t agents:0.0 'cat .ai/instructions/leader.md'
tmux send-keys -t agents:0.0 C-m

# engineer-1 (pane 1)
echo "💻 engineer-1起動中..."
tmux send-keys -t agents:0.1 'claude'
tmux send-keys -t agents:0.1 C-m
sleep 3
tmux send-keys -t agents:0.1 'cat .ai/instructions/engineer.md'
tmux send-keys -t agents:0.1 C-m

# engineer-2 (pane 2)
echo "🖥️ engineer-2起動中..."
tmux send-keys -t agents:0.2 'claude'
tmux send-keys -t agents:0.2 C-m
sleep 3
tmux send-keys -t agents:0.2 'cat .ai/instructions/engineer.md'
tmux send-keys -t agents:0.2 C-m

# engineer-3 (pane 3)
echo "⚙️ engineer-3起動中..."
tmux send-keys -t agents:0.3 'claude'
tmux send-keys -t agents:0.3 C-m
sleep 3
tmux send-keys -t agents:0.3 'cat .ai/instructions/engineer.md'
tmux send-keys -t agents:0.3 C-m

# qa-agent (pane 4)
echo "🧪 qa-agent起動中..."
tmux send-keys -t agents:0.4 'claude'
tmux send-keys -t agents:0.4 C-m
sleep 3
tmux send-keys -t agents:0.4 'cat .ai/instructions/qa-agent.md'
tmux send-keys -t agents:0.4 C-m

echo "✅ 全エージェント起動完了！"
echo ""
echo "🎯 次のステップ:"
echo "1. agentsセッションのLEADERペインで: 'あなたはleaderです。指示書に従ってプロジェクトを開始してください'"
echo "2. 自動的にエージェント間の直接通信が開始されます"
echo ""
echo "📊 セッション確認:"
echo "  tmux attach-session -t agents" 