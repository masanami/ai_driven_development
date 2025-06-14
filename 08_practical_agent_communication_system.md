# 実用的エージェント間コミュニケーションシステム

## 🎯 概要

マルチエージェント開発における直接通信プロトコル。

---

## 🚨 エージェント間通信プロトコル【最重要】

### **基本通信フォーマット**
- **LEADERからエンジニア**: `**engineer-{番号}への指示:** {内容}`
- **エンジニアからLEADER**: `**LEADERへの報告:** {内容}`  
- **エンジニア間連絡**: `**engineer-{番号}への連絡:** {内容}`
- **QAエージェント通信**: `**qa-agentへの連絡:** {内容}` / `**qa-agentからの報告:** {内容}`

### **🚨 CRITICAL: agent-send.sh必須使用ルール**

**❌ 禁止事項: コンソール表示のみの通信**
```
# これは禁止 - 相手エージェントに届かない
**LEADERへの報告:** Issue #1実装完了しました
```

**✅ 必須事項: agent-send.shコマンド実行**
```bash
# 必ずこの形式でコマンド実行する
./ai-framework/scripts/agent-send.sh leader "**LEADERへの報告:** Issue #1実装完了しました"
```

**通信手順:**
1. **コンソール表示は禁止** - 相手エージェントに届かない
2. **必ずagent-send.shコマンドを実行** - 実際の通信を行う
3. **通信後は相手からの応答を待つ** - 一方的な通信は避ける

**利用可能なエージェント名:**
- `leader` - LEADERエージェント
- `engineer-1` - エンジニアエージェント1
- `engineer-2` - エンジニアエージェント2  
- `engineer-3` - エンジニアエージェント3
- `qa-agent` - QAエージェント

---

## 📋 通信コマンド例

### **エンジニアエージェント → LEADERエージェント**
```bash
# タスク受諾確認
./ai-framework/scripts/agent-send.sh leader "**LEADERへの報告:** Issue #{番号}のタスクを受諾しました。実装を開始します。"

# 進捗報告
./ai-framework/scripts/agent-send.sh leader "**LEADERへの報告:** Issue #{番号} - Red Phase完了。テストケース実装済み。"

# 実装完了・PR作成報告
./ai-framework/scripts/agent-send.sh leader "**LEADERへの報告:** Issue #{番号}実装完了。PR #{番号}を作成しました。レビューをお願いします。"

# 課題・ブロッカー報告
./ai-framework/scripts/agent-send.sh leader "**LEADERへの報告:** Issue #{番号}で技術的課題が発生しました。{詳細}について相談があります。"
```

### **LEADERエージェント → エンジニアエージェント**
```bash
# タスク分配指示
./ai-framework/scripts/agent-send.sh engineer-1 "**engineer-1への指示:** Issue #{番号}（{機能名}）を担当してください。実装完了後、PR作成して報告してください。"

# レビュー結果・マージ指示
./ai-framework/scripts/agent-send.sh engineer-1 "**engineer-1への連絡:** PR #{番号}をレビューしました。依存関係に問題なし。mainブランチにマージします。"

# 統合テスト指示
./ai-framework/scripts/agent-send.sh engineer-2 "**engineer-2への連絡:** PR #{番号}レビュー中。認証機能との統合テストを実行してください。"
```

### **エンジニアエージェント間の直接連携**
```bash
# 技術仕様共有
./ai-framework/scripts/agent-send.sh engineer-2 "**engineer-2への連絡:** 認証APIの仕様が決まりました。エンドポイント /api/auth/login を使用してください。"

# 協力依頼
./ai-framework/scripts/agent-send.sh engineer-3 "**engineer-3への連絡:** データ管理APIが完成しました。統合機能の実装で連携をお願いします。"

# 緊急連絡
./ai-framework/scripts/agent-send.sh engineer-3 "**engineer-3への連絡:** 緊急です。統合APIでエラーが発生しています。詳細を確認してください。"
```

### **QAエージェントとの連携**
```bash
# テスト依頼
./ai-framework/scripts/agent-send.sh qa-agent "**qa-agentへの連絡:** Issue #{番号}の実装が完了しました。統合テストをお願いします。"

# テスト結果報告
./ai-framework/scripts/agent-send.sh leader "**LEADERへの報告:** 統合テスト完了。品質基準を満たしています。"
```

---

## 🔄 実際の通信フロー

### **並列実装・逐次統合の完全フロー**
```bash
# 1. LEADER → エンジニア: タスク分配
./ai-framework/scripts/agent-send.sh engineer-1 "**engineer-1への指示:** Issue #1（認証機能）を担当してください。"

# 2. エンジニア → LEADER: タスク受諾
./ai-framework/scripts/agent-send.sh leader "**LEADERへの報告:** Issue #1のタスクを受諾しました。実装を開始します。"

# 3. エンジニア → LEADER: 実装完了報告
./ai-framework/scripts/agent-send.sh leader "**LEADERへの報告:** Issue #1実装完了。PR #1を作成しました。レビューをお願いします。"

# 4. LEADER → エンジニア: レビュー結果
./ai-framework/scripts/agent-send.sh engineer-1 "**engineer-1への連絡:** PR #1をレビューしました。mainブランチにマージします。"
```

### **エンジニア間技術連携フロー**
```bash
# 1. エンジニア1 → エンジニア2: 仕様共有
./ai-framework/scripts/agent-send.sh engineer-2 "**engineer-2への連絡:** 認証API仕様が決まりました。/api/auth/login を使用してください。"

# 2. エンジニア2 → エンジニア1: 確認応答
./ai-framework/scripts/agent-send.sh engineer-1 "**engineer-1への連絡:** 認証API仕様を確認しました。データ管理機能で連携します。"
```

---

## ⚠️ 重要な注意事項

### **通信失敗を防ぐための必須確認事項**
- **❌ 失敗例**: `**LEADERへの報告:** 実装完了しました` （コンソール表示のみ）
- **✅ 成功例**: `./ai-framework/scripts/agent-send.sh leader "**LEADERへの報告:** 実装完了しました"`
- **全ての通信でagent-send.shを使用する**
- **宛先エージェント名を正確に指定する**
- **通信フォーマットを厳守する**
- **相手からの応答を確認する** 