#!/bin/bash

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
echo "1) 完全自動セットアップ（推奨）"
echo "2) ステップバイステップ実行"
echo ""

read -p "選択 (1-2): " -n 1 -r
echo ""

case $REPLY in
    1)
        echo "🚀 完全自動セットアップを開始..."
        echo ""
        
        # 1. 環境構築
        echo "📊 Step 1: 環境構築"
        "${SCRIPT_DIR}/setup-agent-communication.sh"
        
        if [ $? -ne 0 ]; then
            echo "❌ 環境構築に失敗しました"
            exit 1
        fi
        
        echo ""
        echo "⏳ 5秒待機中..."
        sleep 5
        
        # 2. エージェント起動
        echo "📊 Step 2: エージェント起動"
        "${SCRIPT_DIR}/start-agents.sh"
        
        if [ $? -ne 0 ]; then
            echo "❌ エージェント起動に失敗しました"
            exit 1
        fi
        
        echo ""
        echo "✅ セットアップ完了！"
        ;;
        
    2)
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
        ;;
esac

echo ""
echo "📚 参考資料:"
echo "   システム仕様: ${SCRIPT_DIR}/08_practical_agent_communication_system.md"
echo "   手動操作: ${SCRIPT_DIR}/agent-send.sh [エージェント名] [メッセージ]"
echo "   ログ確認: tail -f logs/communication.log"
echo ""
echo "🎉 直接通信型エージェントシステムをお楽しみください！" 