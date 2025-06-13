#!/bin/bash

echo "🎬 直接通信デモンストレーション開始"
echo "このデモでは、LEADERが各エージェントに直接指示を出し、"
echo "エージェント間で自動的に連携する様子を確認できます。"
echo ""

# デモ実行確認
read -p "デモを開始しますか？ (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "デモを中止しました"
    exit 1
fi

echo "📡 デモシナリオ: ユーザー登録機能の開発"
echo ""

# 1. LEADERからの初期指示
echo "🎯 Step 1: LEADERからの初期指示送信"
sleep 2

echo "→ engineer-1への指示送信..."
./agent-send.sh leader "engineer-1への指示: あなたはengineer-1です。ユーザー登録画面のReactコンポーネントを実装してください。フォームにはemail、password、name入力欄を含め、バリデーション機能も実装してください。完了したら「engineer-1実装完了」と報告してください。"

sleep 3

echo "→ engineer-2への指示送信..."
./agent-send.sh leader "engineer-2への指示: あなたはengineer-2です。ユーザー登録API(/api/users/register)を実装してください。POST形式で{ email, password, name }を受け取り、データベースに保存してJWTトークンを返すAPIを作成してください。完了したら「engineer-2実装完了」と報告してください。"

sleep 3

echo "→ qa-agentへの指示送信..."
./agent-send.sh leader "qa-agentへの指示: あなたはqa-agentです。ユーザー登録機能のテストケースを設計・実行してください。正常系・異常系・境界値テストを含めた包括的なテストを行ってください。完了したら「qa-agent完了」と報告してください。"

sleep 5

# 2. エージェント間連携のシミュレーション
echo ""
echo "🔄 Step 2: エージェント間の直接連携シミュレーション"
sleep 2

echo "→ engineer-1からengineer-2への連絡..."
./agent-send.sh engineer-1 "engineer-2への連絡: フロントエンドからAPIエンドポイント /api/users/register にPOSTリクエストを送信します。リクエスト形式は { email: string, password: string, name: string } で間違いないでしょうか？また、エラー時のレスポンス形式も教えてください。"

sleep 5

echo "→ engineer-2からengineer-1への返答..."
./agent-send.sh engineer-2 "engineer-1への連絡: リクエスト形式は正しいです。エラー時は { error: string, details?: any } 形式で返します。ステータスコードは400（バリデーションエラー）、409（重複エラー）、500（サーバーエラー）を使用します。"

sleep 5

echo "→ engineer-2からqa-agentへの実装完了通知..."
./agent-send.sh engineer-2 "qa-agentへの連絡: ユーザー登録API(/api/users/register)の実装が完了しました。テストをお願いします。エンドポイントはPOST /api/users/register で、成功時は201ステータスとJWTトークンを返します。"

sleep 5

# 3. QAからの質問・確認
echo ""
echo "🧪 Step 3: QAエージェントからの確認・テスト"
sleep 2

echo "→ qa-agentからengineer-1への質問..."
./agent-send.sh qa-agent "engineer-1への質問: ユーザー登録フォームでのバリデーションエラーはどのように表示されますか？また、パスワード強度の要件を教えてください。"

sleep 5

echo "→ qa-agentからengineer-2への質問..."
./agent-send.sh qa-agent "engineer-2への質問: APIで重複するemailアドレスが登録された場合の詳細なエラーメッセージを教えてください。レスポンスの具体例もお願いします。"

sleep 5

# 4. 最終報告
echo ""
echo "📊 Step 4: 完了報告"
sleep 2

echo "→ engineer-1からLEADERへの報告..."
./agent-send.sh engineer-1 "LEADERへの報告: engineer-1の実装が完了しました。ユーザー登録フォーム、リアルタイムバリデーション、エラーハンドリング、レスポンシブデザインを実装済みです。qa-agentと連携してテストも完了しています。"

sleep 3

echo "→ engineer-2からLEADERへの報告..."
./agent-send.sh engineer-2 "LEADERへの報告: engineer-2の実装が完了しました。ユーザー登録API、データベース連携、JWTトークン生成、エラーハンドリングを実装済みです。qa-agentのテストも全て通過しています。"

sleep 3

echo "→ qa-agentからLEADERへの最終報告..."
./agent-send.sh qa-agent "LEADERへの報告: qa-agentのテストが完了しました。全32件のテストケースが成功し、コードカバレッジ95%、パフォーマンステストも基準をクリアしています。本番リリース準備完了です。"

sleep 3

echo ""
echo "🎉 デモ完了！"
echo ""
echo "📈 直接通信システムの効果:"
echo "✅ リアルタイムでのエージェント間連携"
echo "✅ 自然な質疑応答・情報共有"
echo "✅ 迅速な問題解決・調整"
echo "✅ チーム全体の進捗可視化"
echo ""
echo "📝 ログを確認:"
echo "  tail -f logs/communication.log"
echo ""
echo "🔍 各エージェントの動作確認:"
echo "  tmux attach-session -t leader      # LEADER"
echo "  tmux attach-session -t multiagent  # 全エージェント" 