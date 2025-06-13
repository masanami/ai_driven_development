#!/bin/bash

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🎬 直接通信デモ - 簡易TODOアプリ開発"
echo ""

# tmuxセッション確認
if ! tmux has-session -t leader 2>/dev/null || ! tmux has-session -t multiagent 2>/dev/null; then
    echo "❌ tmuxセッションが見つかりません"
    echo "   先に ./setup-agent-communication.sh と ./start-agents.sh を実行してください"
    exit 1
fi

echo "✅ tmuxセッション確認完了"
echo ""

echo "📋 デモシナリオ: 簡易TODOアプリの協調開発"
echo "   - LEADER: プロジェクト管理・タスク分配"
echo "   - engineer-1: フロントエンド実装（React TODO UI）"
echo "   - engineer-2: バックエンドAPI実装（TODO CRUD API）"  
echo "   - engineer-3: 待機中（必要時に動的アサイン）"
echo "   - qa-agent: テスト設計・実行"
echo ""

# Phase 1: LEADERからの初期タスク分配
echo "🚀 Phase 1: LEADERからの初期タスク分配"
"${SCRIPT_DIR}/agent-send.sh" leader "engineer-1への指示: あなたはengineer-1です。TODOアプリのフロントエンドを実装してください。TODO追加フォーム、TODO一覧表示、完了チェック、削除ボタンを含むReactコンポーネントを作成してください。完了したら「engineer-1実装完了」と報告してください。"

sleep 2

"${SCRIPT_DIR}/agent-send.sh" leader "engineer-2への指示: あなたはengineer-2です。TODOアプリのバックエンドAPIを実装してください。GET /api/todos（一覧取得）、POST /api/todos（追加）、PUT /api/todos/:id（更新）、DELETE /api/todos/:id（削除）のCRUD APIを作成してください。完了したら「engineer-2実装完了」と報告してください。"

sleep 2

"${SCRIPT_DIR}/agent-send.sh" leader "qa-agentへの指示: あなたはqa-agentです。TODOアプリの機能テストを設計・実行してください。TODO追加、表示、完了切り替え、削除の各機能をテストしてください。完了したら「qa-agent完了」と報告してください。"

echo "⏳ 5秒待機（エージェントの初期処理時間）"
sleep 5

# Phase 2: エージェント間の直接通信
echo ""
echo "🔄 Phase 2: エージェント間の直接通信・協調"
"${SCRIPT_DIR}/agent-send.sh" engineer-1 "engineer-2への連絡: フロントエンドからTODO APIを呼び出します。TODOデータの形式は { id: number, title: string, completed: boolean, createdAt: string } で良いでしょうか？また、API のレスポンス形式を教えてください。"

sleep 3

"${SCRIPT_DIR}/agent-send.sh" engineer-2 "engineer-1への連絡: TODOデータ形式は正しいです。APIレスポンスは成功時に { success: true, data: Todo[] } 、エラー時に { success: false, error: string } 形式で返します。ステータスコードは200（成功）、400（バリデーションエラー）、500（サーバーエラー）です。"

sleep 3

"${SCRIPT_DIR}/agent-send.sh" engineer-2 "qa-agentへの連絡: TODO CRUD APIの実装が完了しました。テストをお願いします。エンドポイント: GET /api/todos, POST /api/todos, PUT /api/todos/:id, DELETE /api/todos/:id が利用可能です。"

echo "⏳ 8秒待機（実装・テスト時間）"
sleep 8

# Phase 3: QAエージェントからの質問・確認
echo ""
echo "🧪 Phase 3: QAエージェントからの詳細確認"
"${SCRIPT_DIR}/agent-send.sh" qa-agent "engineer-1への質問: TODO追加時のバリデーション（空文字チェックなど）はどのように実装されていますか？また、完了済みTODOの表示スタイルはどうなっていますか？"

sleep 3

"${SCRIPT_DIR}/agent-send.sh" qa-agent "engineer-2への質問: TODO削除時の確認処理はありますか？また、存在しないTODO IDに対する操作時のエラーハンドリングはどのように実装されていますか？"

echo "⏳ 10秒待機（テスト実行・検証時間）"
sleep 10

# Phase 4: 完了報告
echo ""
echo "✅ Phase 4: 各エージェントからLEADERへの完了報告"
"${SCRIPT_DIR}/agent-send.sh" engineer-1 "LEADERへの報告: engineer-1の実装が完了しました。TODO追加フォーム、一覧表示、完了チェックボックス、削除ボタン、バリデーション機能、レスポンシブデザインを実装済みです。qa-agentと連携してテストも完了しています。"

sleep 2

"${SCRIPT_DIR}/agent-send.sh" engineer-2 "LEADERへの報告: engineer-2の実装が完了しました。TODO CRUD API、データベース連携、バリデーション、エラーハンドリング、CORS設定を実装済みです。qa-agentのテストも全て通過しています。"

sleep 2

"${SCRIPT_DIR}/agent-send.sh" qa-agent "LEADERへの報告: qa-agentのテストが完了しました。全24件のテストケース（フロントエンド12件、API12件）が成功し、TODO追加・表示・完了・削除の全機能が正常に動作しています。本番リリース準備完了です。"

echo ""
echo "🎉 TODOアプリデモ完了！"
echo ""
echo "📺 各セッションの確認:"
echo "   tmux attach-session -t leader      # LEADER画面"
echo "   tmux attach-session -t multiagent  # 全エージェント画面"
echo ""
echo "📊 通信ログ確認:"
echo "   tail -f logs/communication.log"
echo ""
echo "💡 このデモでは以下の直接通信パターンを実演しました:"
echo "   1. LEADERから各エージェントへのタスク分配"
echo "   2. エージェント間の直接的な技術相談・API仕様確認"
echo "   3. QAエージェントからの機能確認・品質チェック"
echo "   4. 各エージェントからLEADERへの完了報告"
echo ""
echo "🔧 engineer-3について:"
echo "   - 現在は待機状態です"
echo "   - 必要に応じてLEADERが動的にタスクをアサインできます"
echo "   - 例: ./agent-send.sh leader \"engineer-3への指示: [タスク内容]\""
echo ""
echo "📝 実装されたTODOアプリ機能:"
echo "   ✅ TODO追加・一覧表示"
echo "   ✅ 完了状態の切り替え"
echo "   ✅ TODO削除"
echo "   ✅ バリデーション・エラーハンドリング"
echo ""
echo "🚀 実際の開発では、このような基本的なCRUDアプリから始めて段階的に機能を拡張していきます！" 