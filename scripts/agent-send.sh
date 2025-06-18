#!/bin/bash
set -euo pipefail

# 直接通信メッセージ送信スクリプト

AGENT_NAME=$1
shift  # 第1引数を除去
MESSAGE="$*"  # 残りの引数をすべてメッセージとして結合
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# プロジェクトルートを特定（.gitディレクトリを基準）
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [ -z "$PROJECT_ROOT" ]; then
    echo "❌ Gitリポジトリのルートが見つかりません"
    exit 1
fi

LOCK_FILE="$PROJECT_ROOT/.ai/logs/communication.lock"
LOG_FILE="$PROJECT_ROOT/.ai/logs/communication.log"
MAX_WAIT=60  # 最大待機時間（秒）

# 引数チェック
if [ -z "$AGENT_NAME" ] || [ -z "$MESSAGE" ]; then
    echo "使用方法: ./ai-framework/scripts/agent-send.sh [エージェント名] [メッセージ]"
    echo ""
    echo "利用可能なエージェント:"
    echo "  leader      (pane 0)"
    echo "  engineer-1  (pane 1)"
    echo "  engineer-2  (pane 2)"
    echo "  engineer-3  (pane 3)"
    echo "  qa-agent    (pane 4)"
    echo ""
    echo "直接通信例:"
    echo "  ./ai-framework/scripts/agent-send.sh engineer-1 'engineer-2への連絡: API仕様について相談があります'"
    echo "  ./ai-framework/scripts/agent-send.sh engineer-3 'qa-agentへの連絡: 統合テストをお願いします'"
    echo "  ./ai-framework/scripts/agent-send.sh qa-agent 'LEADERへの報告: テスト完了しました'"
    echo ""
    echo "worktreeからの実行例:"
    echo "  cd worktrees/issue-1-auth/"
    echo "  ../../ai-framework/scripts/agent-send.sh engineer-2 'LEADERへの報告: 認証機能実装完了'"
    exit 1
fi

# ロック取得関数
acquire_lock() {
    local wait_time=0
    while [ -f "$LOCK_FILE" ]; do
        if [ $wait_time -ge $MAX_WAIT ]; then
            echo "❌ 通信ロック取得タイムアウト（${MAX_WAIT}秒）"
            exit 1
        fi
        echo "⏳ 他のエージェントが通信中です。待機中... (${wait_time}s)"
        sleep 5
        wait_time=$((wait_time + 5))
    done
    
    # ロックファイル作成（実行場所も記録）
    echo "$AGENT_NAME:$$:$TIMESTAMP:$(pwd)" > "$LOCK_FILE"
    echo "🔒 通信ロック取得: $AGENT_NAME (from $(pwd))"
}

# ロック解放関数
release_lock() {
    if [ -f "$LOCK_FILE" ]; then
        rm "$LOCK_FILE"
        echo "🔓 通信ロック解放: $AGENT_NAME"
    fi
}

# 異常終了時のクリーンアップ（ロック取得時のみ）
cleanup_on_exit() {
    if [ "$LOCK_ACQUIRED" = "true" ]; then
        release_lock
    fi
    exit 1
}
trap 'cleanup_on_exit' INT TERM

# ロック取得判定（リーダーへの送信時のみロック必要）
need_lock() {
    # リーダーへの送信時はロック必要（複数エージェントからの同時報告を防ぐ）
    if [ "$AGENT_NAME" = "leader" ]; then
        return 0  # ロック必要
    fi
    
    # エンジニアへの送信はロック不要（リーダーからの指示、エンジニア同士の連絡）
    return 1  # ロック不要
}

# 必要な場合のみロック取得
if need_lock; then
    acquire_lock
    LOCK_ACQUIRED=true
else
    LOCK_ACQUIRED=false
    echo "🚀 エンジニアへの送信: ロック不要で直接送信"
fi

# エージェント別送信処理
case $AGENT_NAME in
    "leader")
        tmux send-keys -t agents:0.0 "$MESSAGE"
        sleep 1
        tmux send-keys -t agents:0.0 C-m
        ;;
    "engineer-1")
        tmux send-keys -t agents:0.1 "$MESSAGE"
        sleep 1
        tmux send-keys -t agents:0.1 C-m
        ;;
    "engineer-2")
        tmux send-keys -t agents:0.2 "$MESSAGE"
        sleep 1
        tmux send-keys -t agents:0.2 C-m
        ;;
    "engineer-3")
        tmux send-keys -t agents:0.3 "$MESSAGE"
        sleep 1
        tmux send-keys -t agents:0.3 C-m
        ;;
    "qa-agent")
        tmux send-keys -t agents:0.4 "$MESSAGE"
        sleep 1
        tmux send-keys -t agents:0.4 C-m
        ;;
    *)
        echo "❌ 未知のエージェント: $AGENT_NAME"
        echo "利用可能なエージェント: leader, engineer-1, engineer-2, engineer-3, qa-agent"
        exit 1
        ;;
esac

# ログ記録
echo "[$TIMESTAMP] Direct message to $AGENT_NAME: $MESSAGE" >> "$LOG_FILE"
echo "✅ 直接メッセージ送信完了: $AGENT_NAME"

# 必要な場合のみロック解放
if [ "$LOCK_ACQUIRED" = "true" ]; then
    release_lock
fi 