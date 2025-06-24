# 実用的エージェント間コミュニケーションシステム

## 🎯 概要

マルチエージェント開発における直接通信プロトコル。

---

## 🚨 エージェント間通信プロトコル【最重要】

### **基本通信フォーマット**
- **LEADERからエンジニア**: `**engineer-{番号}への指示:** {内容}`
- **エンジニアからLEADER**: `**LEADERへの報告:** {内容}`  
- **エンジニア間連絡**: `**engineer-{番号}への連絡:** {内容}`

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

---

## 📋 通信コマンド例

### **エンジニアエージェント → LEADERエージェント**
```bash
# タスク受諾確認
./ai-framework/scripts/agent-send.sh leader "**LEADERへの報告:** Issue #{番号}のタスクを受諾しました。実装を開始します。"

# 進捗報告
./ai-framework/scripts/agent-send.sh leader "**LEADERへの報告:** Issue #{番号} - Red Phase完了。テストケース実装済み。"

# 実装完了・PR作成報告
./ai-framework/scripts/agent-send.sh leader "**LEADERへの報告:** Issue #{番号}実装完了。PR #{番号}を作成しました。AI自動レビューツール・ユーザーレビュー依頼中。"

# 課題・ブロッカー報告
./ai-framework/scripts/agent-send.sh leader "**LEADERへの報告:** Issue #{番号}で技術的課題が発生しました。{詳細}について相談があります。"
```

### **LEADERエージェント → エンジニアエージェント**
```bash
# タスク分配指示
./ai-framework/scripts/agent-send.sh engineer-1 "**engineer-1への指示:** Issue #{番号}（{機能名}）を担当してください。実装完了後、PR作成して報告してください。"

# マージ報告
./ai-framework/scripts/agent-send.sh engineer-1 "**engineer-1への連絡:** PR #{番号}のレビューが承認されました。依存関係に問題なし。mainブランチにマージします。"

# 統合テスト指示
./ai-framework/scripts/agent-send.sh engineer-2 "**engineer-2への連絡:** PR #{番号}レビュー中。認証機能との統合テストを実行してください。"

# 品質確認指示
./ai-framework/scripts/agent-send.sh engineer-3 "**engineer-3への連絡:** E2Eテストスイートを実行して統合品質を確認してください。"
```

### **エンジニアエージェント間の直接連携**
```bash
# 技術仕様共有
./ai-framework/scripts/agent-send.sh engineer-2 "**engineer-2への連絡:** 認証APIの仕様が決まりました。エンドポイント /api/auth/login を使用してください。"

# 協力依頼
./ai-framework/scripts/agent-send.sh engineer-3 "**engineer-3への連絡:** データ管理APIが完成しました。統合機能の実装で連携をお願いします。"

# 緊急連絡
./ai-framework/scripts/agent-send.sh engineer-3 "**engineer-3への連絡:** 緊急です。統合APIでエラーが発生しています。詳細を確認してください。"

# 品質情報共有
./ai-framework/scripts/agent-send.sh engineer-1 "**engineer-1への連絡:** 単体テストで境界値エラーを発見しました。同様のケースをチェックしてください。"
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
./ai-framework/scripts/agent-send.sh leader "**LEADERへの報告:** Issue #1実装完了。PR #1を作成しました。AI自動レビューツール・ユーザーレビュー依頼中。"

# 4. LEADER → エンジニア: マージ報告
./ai-framework/scripts/agent-send.sh engineer-1 "**engineer-1への連絡:** PR #1のレビューが承認されました。mainブランチにマージします。"
```

### **エンジニア間技術連携フロー**
```bash
# 1. エンジニア1 → エンジニア2: 仕様共有
./ai-framework/scripts/agent-send.sh engineer-2 "**engineer-2への連絡:** 認証API仕様が決まりました。/api/auth/login を使用してください。"

# 2. エンジニア2 → エンジニア1: 確認応答
./ai-framework/scripts/agent-send.sh engineer-1 "**engineer-1への連絡:** 認証API仕様を確認しました。データ管理機能で連携します。"
```

### **品質保証統合フロー**
```bash
# 1. エンジニア → LEADER: 品質確認完了報告
./ai-framework/scripts/agent-send.sh leader "**LEADERへの報告:** Issue #1 - 単体テスト・統合テストすべて成功。品質基準を満たしています。"

# 2. LEADER → 全エンジニア: E2Eテスト指示
./ai-framework/scripts/agent-send.sh engineer-1 "**engineer-1への連絡:** 全機能実装完了。E2Eテストスイートを実行してください。"
./ai-framework/scripts/agent-send.sh engineer-2 "**engineer-2への連絡:** 全機能実装完了。E2Eテストスイートを実行してください。"
./ai-framework/scripts/agent-send.sh engineer-3 "**engineer-3への連絡:** 全機能実装完了。E2Eテストスイートを実行してください。"
```

---

## ⚠️ 重要な注意事項

### **🚨 CRITICAL: 業務専用通信ルール【厳守】**

**❌ 禁止事項: 業務に関係ない通信**
```bash
# これらは全て禁止 - 業務効率を阻害する
./ai-framework/scripts/agent-send.sh engineer-1 "調子はどうですか？"
./ai-framework/scripts/agent-send.sh leader "今日は天気がいいですね"
./ai-framework/scripts/agent-send.sh engineer-2 "お疲れ様です！頑張りましょう"
```

**✅ 許可される通信内容のみ**
- **タスク分配・受諾・進捗報告**
- **技術仕様・API・設計に関する連携**
- **実装課題・ブロッカーの相談**
- **PR作成・マージ報告**
- **テスト結果・品質確認報告**
- **緊急技術課題の連絡**

**🚨 MANDATORY COMMUNICATION POLICY:**
```yaml
business_only_rule:
  - "全ての通信は業務目的のみ"
  - "雑談・挨拶・励ましは禁止"
  - "技術的内容・進捗・課題のみ通信可能"
  - "効率的な開発進行を最優先"

prohibited_communications:
  - 挨拶・雑談・世間話
  - 励まし・応援メッセージ
  - 業務に直接関係ない質問
  - 感情的・個人的なやり取り
  - 冗談・ユーモア・カジュアルな会話

allowed_communications:
  - タスク関連の指示・報告・確認
  - 技術仕様・API・設計の共有・質問
  - 実装課題・エラー・ブロッカーの報告
  - PR作成・マージ・品質確認の結果
  - 緊急事態・重要な技術的変更の連絡
  - 品質保証・テスト結果の報告
```

### **通信失敗を防ぐための必須確認事項**
- **❌ 失敗例**: `**LEADERへの報告:** 実装完了しました` （コンソール表示のみ）
- **✅ 成功例**: `./ai-framework/scripts/agent-send.sh leader "**LEADERへの報告:** 実装完了しました"`
- **全ての通信でagent-send.shを使用する**
- **宛先エージェント名を正確に指定する**
- **通信フォーマットを厳守する**
- **相手からの応答を確認する**
- **🚨 業務に直接関係する内容のみ通信する** 