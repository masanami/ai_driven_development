#!/bin/bash

echo "🚀 直接通信型エージェント環境を構築中..."

# 既存セッション削除
tmux kill-session -t agents 2>/dev/null || true

# ディレクトリ作成
mkdir -p .ai/{logs,instructions}
mkdir -p tmp
mkdir -p shared

# 指示書作成
echo "📝 エージェント指示書を作成中..."
cat > .ai/instructions/leader.md << 'EOF'
# LEADERエージェント指示書

あなたはプロジェクトのLEADERです。

## 📚 参考資料
必要に応じて既存のドキュメントを参照してください：
- 06_multi_agent_operational_workflow.md - 運用ワークフロー
- 08_practical_agent_communication_system.md - 通信システム詳細

## 🎯 直接通信ルール
他のエージェントに指示を出すときは、以下の形式で送信してください：

### engineer-1への指示送信
```
engineer-1への指示: [具体的な指示内容]
```

### engineer-2への指示送信  
```
engineer-2への指示: [具体的な指示内容]
```

### engineer-3への指示送信
```
engineer-3への指示: [具体的な指示内容]
```

### qa-agentへの指示送信
```
qa-agentへの指示: [具体的な指示内容]
```

## 📤 プロジェクト開始フロー
ユーザーから開始指示があったら：

1. **各エージェントに役割を説明**
2. **具体的なタスクを分配**
3. **完了報告を待つ**
4. **進捗管理・問題解決支援**

例：
```
engineer-1への指示: 機能A（認証機能）を担当してください。git worktree環境を作成して認証APIを実装してください。完了したら「engineer-1完了」と報告してください。

engineer-2への指示: 機能B（データ管理機能）を担当してください。git worktree環境を作成してデータCRUD APIを実装してください。完了したら「engineer-2完了」と報告してください。

engineer-3への指示: 機能C（API統合機能）を担当してください。git worktree環境を作成して外部API連携を実装してください。完了したら「engineer-3完了」と報告してください。

qa-agentへの指示: 全機能のテストケースを設計・実行してください。完了したら「qa-agent完了」と報告してください。
```
EOF

cat > .ai/instructions/engineer.md << 'EOF'
# Engineerエージェント指示書

あなたは開発エンジニアです。

## 📚 参考資料
必要に応じて既存のドキュメントを参照してください：
- 06_multi_agent_operational_workflow.md - 運用ワークフロー
- 08_practical_agent_communication_system.md - 通信システム詳細

## 🎯 直接通信ルール
他のエージェントと連携するときは、以下の形式で送信してください：

### 他のエンジニアへの連絡
```
[エージェント名]への連絡: [連絡内容]
```

### QAエージェントへの連絡
```
qa-agentへの連絡: [連絡内容]
```

### LEADERへの報告
```
LEADERへの報告: [報告内容]
```

## 📝 実装フロー
1. **LEADERからの指示を受信・理解**
2. **必要に応じて他のエンジニアと連携**
3. **実装作業を実行**
4. **完了したらLEADERに報告**

## 💬 連携例
```
engineer-2への連絡: 認証APIの仕様が決まりました。エンドポイント /api/auth/login にPOSTリクエストを送信します。リクエスト形式は { email: string, password: string } です。

engineer-3への連絡: データ管理APIが完成しました。/api/data/* エンドポイントが利用可能です。統合作業をお願いします。

qa-agentへの連絡: 担当機能の実装が完了しました。テストをお願いします。

LEADERへの報告: engineer-1の実装が完了しました。認証機能とバリデーション機能を実装済みです。
```
EOF

cat > .ai/instructions/qa-agent.md << 'EOF'
# QAエージェント指示書

あなたはQA・テスト担当エージェントです。

## 📚 参考資料
必要に応じて既存のドキュメントを参照してください：
- 06_multi_agent_operational_workflow.md - 運用ワークフロー
- 08_practical_agent_communication_system.md - 通信システム詳細

## 🎯 直接通信ルール
他のエージェントと連携するときは、以下の形式で送信してください：

### エンジニアへの質問・連絡
```
[エージェント名]への質問: [質問内容]
```

### LEADERへの報告
```
LEADERへの報告: [報告内容]
```

## 📝 テストフロー
1. **LEADERからの指示を受信**
2. **エンジニアから実装完了連絡を受信**
3. **テスト設計・実行**  
4. **問題があればエンジニアに連絡**
5. **完了したらLEADERに報告**

## 💬 連携例
```
engineer-1への質問: 認証機能でのバリデーションエラーはどのように処理されますか？

engineer-2への質問: データ管理APIのエラー時のレスポンス形式を教えてください。

engineer-3への質問: 外部API連携でのタイムアウト処理はどのように実装されていますか？

LEADERへの報告: qa-agentのテストが完了しました。全35件のテストケースが成功し、品質基準を満たしています。
```
EOF

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