#!/bin/bash

echo "🚀 直接通信型エージェント環境を構築中..."

# 既存セッション削除
tmux kill-session -t agents 2>/dev/null || true

# ディレクトリ作成
mkdir -p .ai/{logs,instructions}
mkdir -p tmp
mkdir -p shared

# テンプレートファイルから指示書作成
echo "📝 テンプレートファイルから指示書を作成中..."

# テンプレートファイルの存在確認
if [[ ! -f "leader_agent_setup_template.md" ]]; then
    echo "❌ エラー: leader_agent_setup_template.md が見つかりません"
    exit 1
fi

if [[ ! -f "engineer_agent_setup_template.md" ]]; then
    echo "❌ エラー: engineer_agent_setup_template.md が見つかりません"
    exit 1
fi

if [[ ! -f "qa_agent_setup_template.md" ]]; then
    echo "❌ エラー: qa_agent_setup_template.md が見つかりません"
    exit 1
fi

# テンプレートファイルをコピーして指示書作成
echo "📋 LEADERエージェント指示書作成..."
cp leader_agent_setup_template.md .ai/instructions/leader.md

echo "💻 Engineerエージェント指示書作成..."
cp engineer_agent_setup_template.md .ai/instructions/engineer.md

echo "🧪 QAエージェント指示書作成..."
cp qa_agent_setup_template.md .ai/instructions/qa-agent.md

# agentsセッション作成（5ペイン）
echo "📊 agentsセッション作成中..."
tmux new-session -d -s agents

# ペイン分割（LEADER 40%, engineer-1 20%, engineer-2 20%, engineer-3 10%, qa-agent 10%）
tmux split-window -h -t agents
tmux split-window -v -t agents:0.1
tmux split-window -v -t agents:0.2
tmux split-window -v -t agents:0.3

# ペイン名設定
tmux send-keys -t agents:0.0 'echo "👑 LEADER ready"' C-m
tmux send-keys -t agents:0.1 'echo "💻 engineer-1 ready"' C-m
tmux send-keys -t agents:0.2 'echo "🖥️ engineer-2 ready"' C-m
tmux send-keys -t agents:0.3 'echo "⚙️ engineer-3 ready"' C-m
tmux send-keys -t agents:0.4 'echo "🧪 qa-agent ready"' C-m

# 通信システム初期化
echo "📡 直接通信システム初期化中..."
echo "$(date): Direct communication system initialized" > .ai/logs/communication.log

echo "✅ セットアップ完了！"
echo ""
echo "📝 使用方法:"
echo "  tmux attach-session -t agents      # 全エージェントセッション"
echo ""
echo "🚀 エージェント起動:"
echo "  ./start-agents.sh" 