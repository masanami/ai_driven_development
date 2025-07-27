#!/bin/bash
set -euo pipefail

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 直接通信型エージェントシステム - クイックスタート"
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

# Claudeコマンドがあるかチェック（claude codeの場合）
if ! command -v claude &> /dev/null; then
    echo "⚠️  claudeコマンドが見つかりません"
    echo "   Claude Codeがインストールされていることを確認してください"
    echo "   または、各ペインで手動でClaude Codeを起動してください"
else
    echo "✅ claude: 利用可能"
fi

echo ""

# ワンクリック実行オプション
echo "🎯 実行オプションを選択してください:"
echo "1) Phase 1-2のみ実行（tmux不使用・リーダーのみ）"
echo "2) Phase 3から開始（tmux使用・並列実装）"
echo "3) ステップバイステップ実行"
echo ""

read -p "選択 (1-3): " -n 1 -r
echo ""

case $REPLY in
    1)
        echo "🚀 Phase 1-2実行（tmux不使用）..."
        echo ""
        "${SCRIPT_DIR}/phase1-2-start.sh"
        ;;
        
    2)
        echo "🚀 Phase 3実行（tmux使用・並列実装）..."
        echo ""
        "${SCRIPT_DIR}/phase3-start.sh"
        ;;
        
    3)
        echo "📋 ステップバイステップ実行"
        echo ""
        
        read -p "Step 1: 環境構築を実行しますか？ (y/N): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            "${SCRIPT_DIR}/setup-agent-communication.sh"
        fi
        
        echo ""
        read -p "Step 2: エージェント起動を実行しますか？ (y/N): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            "${SCRIPT_DIR}/start-agents.sh"
        fi
        
        echo ""
        echo "✅ 選択したステップが完了しました"
        ;;
        
    *)
        echo "❌ 無効な選択です"
        exit 1
        ;;
esac

# Phase 3（tmux使用）の場合のみ追加オプションを表示
if [[ $REPLY =~ ^[2]$ ]] && tmux has-session -t agents 2>/dev/null; then
    echo ""
    echo "🎯 次に何をしますか？"
    echo "1) プロジェクト開始（agentsセッションに接続）"
    echo "2) セッション確認"
    echo "3) 終了"
    echo ""
    
    read -p "選択 (1-3): " -n 1 -r
    echo ""
    
    case $REPLY in
        1)
            echo "📺 agentsセッションに接続します..."
            echo ""
            echo "💡 LEADERペインで以下を入力してください:"
            echo "   'あなたはleaderです。指示書に従ってプロジェクトを開始してください'"
            echo ""
            
            # agentsセッションにアタッチ
            tmux attach-session -t agents
            ;;
            
        2)
            echo "📋 アクティブセッション:"
            tmux list-sessions
            echo ""
            echo "🔧 セッション接続コマンド:"
            echo "   tmux attach-session -t agents      # 全エージェント"
            ;;
            
        3)
            echo "👋 直接通信システムを終了します"
            echo ""
            echo "🧹 リソースクリーンアップ:"
            echo "   tmux kill-session -t agents"
            echo ""
            ;;
            
        *)
            echo "❌ 無効な選択です"
            exit 1
            ;;
    esac
fi

echo ""
echo "📚 参考資料:"
echo "   システム仕様: ${SCRIPT_DIR}/../05_practical_agent_communication_system.md"
echo "   手動操作: ${SCRIPT_DIR}/agent-send.sh [エージェント名] [メッセージ]"
echo "   ログ確認: tail -f logs/communication.log"
echo ""
echo "🎉 直接通信型エージェントシステムをお楽しみください！" 