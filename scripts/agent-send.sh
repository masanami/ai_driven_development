#!/bin/bash

# 直接通信メッセージ送信スクリプト

AGENT_NAME=$1
MESSAGE=$2
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# 引数チェック
if [ -z "$AGENT_NAME" ] || [ -z "$MESSAGE" ]; then
    echo "使用方法: ./agent-send.sh [エージェント名] [メッセージ]"
    echo ""
    echo "利用可能なエージェント:"
    echo "  leader      (pane 0)"
    echo "  engineer-1  (pane 1)"
    echo "  engineer-2  (pane 2)"
    echo "  engineer-3  (pane 3)"
    echo "  qa-agent    (pane 4)"
    echo ""
    echo "直接通信例:"
    echo "  ./agent-send.sh engineer-1 'engineer-2への連絡: API仕様について相談があります'"
    echo "  ./agent-send.sh engineer-3 'qa-agentへの連絡: 統合テストをお願いします'"
    echo "  ./agent-send.sh qa-agent 'LEADERへの報告: テスト完了しました'"
    exit 1
fi

# エージェント別送信処理
case $AGENT_NAME in
    "leader")
        tmux send-keys -t agents:0.0 "$MESSAGE"
        tmux send-keys -t agents:0.0 C-m
        ;;
    "engineer-1")
        tmux send-keys -t agents:0.1 "$MESSAGE"
        tmux send-keys -t agents:0.1 C-m
        ;;
    "engineer-2")
        tmux send-keys -t agents:0.2 "$MESSAGE"
        tmux send-keys -t agents:0.2 C-m
        ;;
    "engineer-3")
        tmux send-keys -t agents:0.3 "$MESSAGE"
        tmux send-keys -t agents:0.3 C-m
        ;;
    "qa-agent")
        tmux send-keys -t agents:0.4 "$MESSAGE"
        tmux send-keys -t agents:0.4 C-m
        ;;
    *)
        echo "❌ 未知のエージェント: $AGENT_NAME"
        echo "利用可能なエージェント: leader, engineer-1, engineer-2, engineer-3, qa-agent"
        exit 1
        ;;
esac

# ログ記録
echo "[$TIMESTAMP] Direct message to $AGENT_NAME: $MESSAGE" >> .ai/logs/communication.log
echo "✅ 直接メッセージ送信完了: $AGENT_NAME" 