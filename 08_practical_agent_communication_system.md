# 実用的エージェント間コミュニケーションシステム

## 🎯 概要

tmuxベースのリアルタイム直接通信システム。

---

## 🏗️ システム構成

### **直接通信型エージェント構成**
```
📊 agents セッション (4ペイン)
├── LEADER (Claude Code): プロジェクト統括・タスク分配
├── engineer-1 (Claude Code): 汎用エンジニア（動的タスク分配）
├── engineer-2 (Claude Code): 汎用エンジニア（動的タスク分配）
├── engineer-3 (Claude Code): 汎用エンジニア（動的タスク分配）
└── qa-agent (Claude Code): QA・テスト担当
```

### **直接通信フロー**
```
🎯 プロジェクト開始フロー:
1. LEADER → engineer-1: "機能A（認証機能）を担当してください"
2. LEADER → engineer-2: "機能B（データ管理機能）を担当してください"
3. LEADER → engineer-3: "機能C（API統合機能）を担当してください"
4. LEADER → qa-agent: "テスト設計・品質保証をお願いします"

🔄 進行中の直接やりとり:
engineer-1 → engineer-2: "認証APIの仕様変更があります。詳細をお送りします"
engineer-2 → engineer-3: "データ管理APIが完成しました。統合をお願いします"
engineer-3 → qa-agent: "API統合完了。テストをお願いします"
qa-agent → LEADER: "テスト完了。品質基準を満たしています"
```

---

## 🚀 直接通信の仕組み

### **tmux send-keysによる直接メッセージ送信**
```bash
# LEADERからengineer-1への直接指示
tmux send-keys -t agents:0.1 '
engineer-1への指示: 機能A（認証機能）を担当してください。
git worktree環境を作成して実装をお願いします。
完了したら「engineer-1実装完了」と報告してください。
' C-m

# engineer-1からengineer-2への直接連絡
tmux send-keys -t agents:0.2 '
engineer-2への連絡: 認証APIの仕様が決まりました。
エンドポイント /api/auth/login を使用してください。
POST形式で { email, password } を送信予定です。
' C-m
```

### **Claude Code指示書による自動応答**
各エージェントは指示書に従って、受信したメッセージに対して自動的に他のエージェントに必要な連絡を取ります。

---

## 🔧 実装

### **セットアップスクリプト**
実際のセットアップは `ai-framework/scripts/setup-agent-communication.sh` で実行されます。

**主な機能:**
- agentsセッション（5ペイン）の作成
- エージェント指示書の自動生成
- ログディレクトリの作成
- 通信システムの初期化

### **エージェント起動スクリプト**
実際のエージェント起動は `ai-framework/scripts/start-agents.sh` で実行されます。

**主な機能:**
- 全5エージェント（LEADER + engineer-1,2,3 + qa-agent）の一括起動
- 各エージェントでのClaude Code起動
- 指示書の自動読み込み
- セッション確認方法の案内

### **直接メッセージ送信システム**
実際のメッセージ送信は `ai-framework/scripts/agent-send.sh` で実行されます。

**主な機能:**
- 5エージェント間での直接メッセージ送信
- tmux send-keysによるリアルタイム通信
- 通信ログの自動記録
- エージェント名の自動検証

---

## 🎯 直接通信の実際の動作フロー

### **プロジェクト開始例**
```bash
# 1. 環境構築・エージェント起動
./ai-framework/scripts/setup-agent-communication.sh
./ai-framework/scripts/start-agents.sh

# 2. LEADERでプロジェクト開始
# agentsセッションのLEADERペインで入力:
"あなたはleaderです。Webアプリの開発プロジェクトを開始してください。指示書に従って各エージェントに動的にタスクを分配してください。"

# 3. LEADERが自動的に各エージェントに直接指示
# → engineer-1への指示: 機能A（認証機能）実装
# → engineer-2への指示: 機能B（データ管理機能）実装
# → engineer-3への指示: 機能C（API統合機能）実装
# → qa-agentへの指示: テスト設計・実行

# 4. エージェント間で直接やりとり
# engineer-1 → engineer-2: 認証API仕様確認
# engineer-2 → engineer-3: データ管理API完了通知
# engineer-3 → qa-agent: 統合実装完了通知
# qa-agent → LEADER: テスト結果報告
```

### **緊急時の直接連絡**
```bash
# 手動で緊急メッセージ送信
./ai-framework/scripts/agent-send.sh engineer-1 "engineer-3への連絡: 緊急です。統合APIでエラーが発生しています。詳細を確認してください。"

# engineer-3が受信後、自動的にLEADERに報告
# engineer-3 → LEADER: "緊急問題を確認中です"
```

---

## 💡 直接通信の利点

✅ **リアルタイム性**
- メッセージ送信と同時に相手エージェントが受信・処理
- ファイル確認待ちなしの即座対応

✅ **対話的**
- エージェント間での自然な会話・質疑応答
- 人間同士のチームワークに近い協調動作

✅ **視覚的管理**
- tmuxペインで各エージェントの活動状況を一目で確認
- リアルタイムでの進捗把握

✅ **柔軟性**
- 予期しない状況での臨機応変な連携
- 複雑な交渉・調整作業への対応

✅ **シンプルさ**
- ファイル管理・フォーマット制約なし
- 自然言語でのストレートな意思疎通

---

## 🚨 制限・注意事項

⚠️ **同期要件**
- 全エージェントが同時起動している必要
- セッション終了で通信履歴が失われる

⚠️ **tmux環境必須**
- macOS/Linuxでのtmux実行環境が必要

⚠️ **Claude Code前提**
- 各ペインでのClaude Code起動・指示書読み込みが前提

---

## 🔄 今後の拡張案

### **通信履歴の永続化**
```bash
# 全セッションの通信をログに記録
tmux capture-pane -t agents:0.0 -p >> logs/leader_history.log
tmux capture-pane -t agents:0.1 -p >> logs/engineer1_history.log
tmux capture-pane -t agents:0.2 -p >> logs/engineer2_history.log
tmux capture-pane -t agents:0.3 -p >> logs/engineer3_history.log
tmux capture-pane -t agents:0.4 -p >> logs/qa_history.log
```

### **自動応答システム**
```bash
# エージェントの応答パターン学習・自動化
# 繰り返し作業の自動実行
```

---

*この直接通信システムにより、ファイルベースでは実現困難だったリアルタイム協調作業が可能になります。エージェント間の自然な対話による効率的な開発体制を実現できます。* 