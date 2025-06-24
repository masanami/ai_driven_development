#!/bin/bash
set -euo pipefail

echo "🚀 直接通信型エージェント環境を構築中..."

# 既存セッション削除
tmux kill-session -t agents 2>/dev/null || true

# ディレクトリ作成
mkdir -p .ai/logs

# テンプレートファイル存在確認
echo "📝 テンプレートファイルの存在確認中..."

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

echo "✅ テンプレートファイル確認完了"

# agentsセッション作成（4ペイン）
echo "📊 agentsセッション作成中..."
tmux new-session -d -s agents

# ペイン分割（各25%ずつ均等配分）
# 最初に縦に分割して左右50%ずつ
tmux split-window -h -t agents -p 50

# 左側を上下に分割（LEADER 25%, engineer-1 25%）
tmux split-window -v -t agents:0.0 -p 50

# 右側を上下に分割（engineer-2 25%, engineer-3 25%）
tmux split-window -v -t agents:0.1 -p 50

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

# ペイン初期化メッセージ
tmux send-keys -t agents:0.0 'echo "👑 LEADER ready"'
tmux send-keys -t agents:0.0 C-m
tmux send-keys -t agents:0.1 'echo "💻 engineer-1 ready"'
tmux send-keys -t agents:0.1 C-m
tmux send-keys -t agents:0.2 'echo "🖥️ engineer-2 ready"'
tmux send-keys -t agents:0.2 C-m
tmux send-keys -t agents:0.3 'echo "⚙️ engineer-3 ready"'
tmux send-keys -t agents:0.3 C-m

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
echo "  ${SCRIPT_DIR}/start-agents.sh" 