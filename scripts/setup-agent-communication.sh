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

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# テンプレートファイルの存在確認
if [[ ! -f "${SCRIPT_DIR}/../templates/leader_agent_setup_template.md" ]]; then
    echo "❌ エラー: templates/leader_agent_setup_template.md が見つかりません"
    exit 1
fi

if [[ ! -f "${SCRIPT_DIR}/../templates/engineer_agent_setup_template.md" ]]; then
    echo "❌ エラー: templates/engineer_agent_setup_template.md が見つかりません"
    exit 1
fi

if [[ ! -f "${SCRIPT_DIR}/../templates/qa_agent_setup_template.md" ]]; then
    echo "❌ エラー: templates/qa_agent_setup_template.md が見つかりません"
    exit 1
fi

# テンプレートファイルをコピーして指示書作成
echo "📋 LEADERエージェント指示書作成..."
cp "${SCRIPT_DIR}/../templates/leader_agent_setup_template.md" .ai/instructions/leader.md

echo "💻 Engineerエージェント指示書作成..."
cp "${SCRIPT_DIR}/../templates/engineer_agent_setup_template.md" .ai/instructions/engineer.md

echo "🧪 QAエージェント指示書作成..."
cp "${SCRIPT_DIR}/../templates/qa_agent_setup_template.md" .ai/instructions/qa-agent.md

# agentsセッション作成（5ペイン）
echo "📊 agentsセッション作成中..."
tmux new-session -d -s agents

# ペイン分割（LEADER 30%, engineer-1 16.7%, engineer-2 16.7%, engineer-3 16.7%, qa-agent 20%）
# 最初に縦に分割してLEADER(30%)とその他(70%)に分ける
tmux split-window -h -t agents -p 70

# 右側を3つに分割（engineer-1, engineer-2, engineer-3）
tmux split-window -v -t agents:0.1 -p 67  # engineer-1 (16.7% of 70% = 23.8%)
tmux split-window -v -t agents:0.2 -p 50  # engineer-2 (16.7% of 70% = 23.8%)
# engineer-3は自動的に残りの23.8%

# 最後にqa-agentを下部に追加（20%）
tmux split-window -v -t agents:0.0 -p 60  # LEADERを上30%、qa-agentを下20%に

# ペインタイトル表示設定
echo "🏷️ ペインタイトル表示設定中..."
tmux set-option -t agents -g pane-border-status top
tmux set-option -t agents -g pane-border-format "#{?pane_active,#[fg=green],#[fg=white]}#{pane_index}: #{pane_title}#[default]"

# ペイン名設定
echo "🏷️ ペイン名設定中..."
tmux select-pane -t agents:0.0 -T "LEADER"
tmux select-pane -t agents:0.1 -T "engineer-1"
tmux select-pane -t agents:0.2 -T "engineer-2"
tmux select-pane -t agents:0.3 -T "engineer-3"
tmux select-pane -t agents:0.4 -T "qa-agent"

# ペイン初期化メッセージ
tmux send-keys -t agents:0.0 'echo "👑 LEADER ready"'
tmux send-keys -t agents:0.0 C-m
tmux send-keys -t agents:0.1 'echo "💻 engineer-1 ready"'
tmux send-keys -t agents:0.1 C-m
tmux send-keys -t agents:0.2 'echo "🖥️ engineer-2 ready"'
tmux send-keys -t agents:0.2 C-m
tmux send-keys -t agents:0.3 'echo "⚙️ engineer-3 ready"'
tmux send-keys -t agents:0.3 C-m
tmux send-keys -t agents:0.4 'echo "🧪 qa-agent ready"'
tmux send-keys -t agents:0.4 C-m

# LEADERペインをアクティブに設定
echo "🎯 LEADERペインをアクティブに設定中..."
tmux select-pane -t agents:0.0

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