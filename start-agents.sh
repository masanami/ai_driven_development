#!/bin/bash

echo "🤖 直接通信型エージェント起動中..."

# 全エージェント一括起動・指示書読み込み
echo "🤖 全エージェント一括起動中..."

# LEADER
echo "👑 LEADER起動中..."
tmux send-keys -t agents:0.0 'claude' C-m
sleep 3
tmux send-keys -t agents:0.0 'cat .ai/instructions/leader.md' C-m

# engineer-1
echo "💻 engineer-1起動中..."
tmux send-keys -t agents:0.1 'claude' C-m
sleep 3
tmux send-keys -t agents:0.1 'cat .ai/instructions/engineer.md' C-m

# engineer-2  
echo "🖥️ engineer-2起動中..."
tmux send-keys -t agents:0.2 'claude' C-m
sleep 3
tmux send-keys -t agents:0.2 'cat .ai/instructions/engineer.md' C-m

# engineer-3
echo "⚙️ engineer-3起動中..."
tmux send-keys -t agents:0.3 'claude' C-m
sleep 3
tmux send-keys -t agents:0.3 'cat .ai/instructions/engineer.md' C-m

# qa-agent
echo "🧪 qa-agent起動中..."
tmux send-keys -t agents:0.4 'claude' C-m
sleep 3
tmux send-keys -t agents:0.4 'cat .ai/instructions/qa-agent.md' C-m

echo "✅ 全エージェント起動完了！"
echo ""
echo "🎯 次のステップ:"
echo "1. agentsセッションのLEADERペインで: 'あなたはleaderです。指示書に従ってプロジェクトを開始してください'"
echo "2. 自動的にエージェント間の直接通信が開始されます"
echo ""
echo "📊 セッション確認:"
echo "  tmux attach-session -t agents" 