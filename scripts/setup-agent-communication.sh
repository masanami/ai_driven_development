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

# AI Framework の基本パス
BASE_PATH="$SCRIPT_DIR/.."

# テンプレートファイルの存在確認
if [[ ! -f "${BASE_PATH}/templates/leader_agent_setup_template.md" ]]; then
    echo "❌ エラー: templates/leader_agent_setup_template.md が見つかりません"
    exit 1
fi

if [[ ! -f "${BASE_PATH}/templates/implementation_engineer_template.md" ]]; then
    echo "❌ エラー: templates/implementation_engineer_template.md が見つかりません"
    exit 1
fi

if [[ ! -f "${BASE_PATH}/templates/quality_engineer_template.md" ]]; then
    echo "❌ エラー: templates/quality_engineer_template.md が見つかりません"
    exit 1
fi

if [[ ! -f "${BASE_PATH}/templates/documentation_engineer_template.md" ]]; then
    echo "❌ エラー: templates/documentation_engineer_template.md が見つかりません"
    exit 1
fi

echo "✅ テンプレートファイル確認完了"

# agentsセッション作成（4ペイン）
echo "📊 agentsセッション作成中..."
tmux new-session -d -s agents
tmux split-window -h -t agents    # 2つ目のペイン作成
tmux split-window -v -t agents:0.0    # 3つ目のペイン作成
tmux split-window -v -t agents:0.1    # 4つ目のペイン作成

# tiledレイアウトを適用して均等分割（25%ずつ）
echo "⚡ tiledレイアウト適用中..."
tmux select-layout -t agents tiled

# ペインタイトル表示設定
echo "🏷️ ペインタイトル表示設定中..."
tmux set-option -t agents -g pane-border-status top
tmux set-option -t agents -g pane-border-format "#{?pane_active,#[fg=green],#[fg=white]}#{pane_index}: #{pane_title}#[default]"

# ペイン名設定
echo "🏷️ ペイン名設定中..."
tmux select-pane -t agents:0.0 -T "LEADER"
tmux select-pane -t agents:0.1 -T "Implementation Engineer"
tmux select-pane -t agents:0.2 -T "Quality Engineer"
tmux select-pane -t agents:0.3 -T "Documentation Engineer"

# ペイン初期化メッセージ
tmux send-keys -t agents:0.0 'echo "👑 LEADER ready"'
tmux send-keys -t agents:0.0 C-m
tmux send-keys -t agents:0.1 'echo "🛠️ Implementation Engineer ready"'
tmux send-keys -t agents:0.1 C-m
tmux send-keys -t agents:0.2 'echo "🧪 Quality Engineer ready"'
tmux send-keys -t agents:0.2 C-m
tmux send-keys -t agents:0.3 'echo "📚 Documentation Engineer ready"'
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