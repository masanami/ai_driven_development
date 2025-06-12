# 📖 AI駆動マルチエージェント開発フレームワーク 使用ガイド

**最小構成でのシンプル導入ガイド**

---

## 🚀 クイックスタート

### **パターン1: ゼロから新規プロジェクト開始**

```bash
# 1. プロジェクト作成
mkdir my-new-project && cd my-new-project

# 2. AIフレームワーク追加
git remote add ai-framework-remote <this-repo-url>
git subtree add --prefix ai-framework ai-framework-remote main --squash

# 3. 最小構成セットアップ
mkdir -p .ai/{workflows,contexts,logs}
mkdir -p .ai/agent_communication/{inbox,outbox,processed,templates}
echo ".ai/logs/" >> .gitignore
echo ".ai/agent_communication/processed/" >> .gitignore

```

### **パターン2: 既存プロジェクトに追加**

```bash
# 1. 既存プロジェクトのルートで実行
cd existing-project

# 2. AIフレームワーク追加
git remote add ai-framework-remote <this-repo-url>
git subtree add --prefix ai-framework ai-framework-remote main --squash

# 3. 最小構成セットアップ  
mkdir -p .ai/{workflows,contexts,logs}
mkdir -p .ai/agent_communication/{inbox,outbox,processed,templates}
echo ".ai/logs/" >> .gitignore
echo ".ai/agent_communication/processed/" >> .gitignore
```

---

## ⚙️ 最小設定

### **Claude Code設定 (.claude/settings.json)**
```json
{
  "ai.referenceDirectories": [
    "ai-framework/",
    ".ai/",
    "src/"
  ]
}
```

### **基本ディレクトリ構造**
```
your-project/
├── ai-framework/          # フレームワーク（自動更新）
├── .ai/
│   ├── workflows/         # 作業手順
│   ├── contexts/          # プロジェクト知識
│   ├── logs/              # 開発記録
│   └── agent_communication/  # エージェント間通信
│       ├── inbox/         # 受信メッセージ
│       ├── outbox/        # 送信メッセージ
│       ├── processed/     # 処理済み（gitignore）
│       └── templates/     # テンプレート
└── src/                   # プロダクトコード
```

---

## 🤖 リーダーエージェント起動・初期設定

### **Leader Agent (Claude Code) セットアップ**

**@ai-framework/leader_agent_setup_template.md** の基本セットアップ指示を使用してください：

```markdown
1. テンプレートから基本セットアップ指示をコピー
2. プロジェクト固有カスタマイズで該当項目を調整
3. Claude Codeに指示として送信
```

---

## 📋 基本的な開発フロー

### **🚀 超簡単スタート**

#### **🆕 新規プロジェクト開発**
```markdown
# Claude Codeに指示
"@ai-framework/leader_agent_setup_template.md の基本セットアップ指示を実行してください。

開発するプロジェクト：
[ここにプロジェクトの概要を記載]
例：「ECサイトのショッピングカート機能を作りたいです。
ユーザーが商品を選んでカートに追加し、決済できるシステムです。」

セットアップ完了後、要件定義から実装まで進めてください。"
```

#### **🔧 ai-framework導入済みプロジェクトの機能追加・改修**
```markdown
# Claude Codeに指示
"@ai-framework/leader_agent_setup_template.md の基本セットアップ指示を実行してください。

既存プロジェクトの機能追加・改修：
[追加・変更したい機能を記載]
例：「既存のECサイトに、商品レビュー機能を追加したいです。
ユーザーが購入した商品にレビューを投稿し、他のユーザーが閲覧できる機能です。」

既存の .ai/knowledge_base/ の情報を参照して、要件定義から実装まで進めてください。"
```

#### **📦 ai-framework未導入プロジェクトの移行 + 機能追加**
```markdown
# Claude Codeに指示
"@ai-framework/leader_agent_setup_template.md の基本セットアップ指示を実行してください。

ai-framework未導入プロジェクトの移行 + 機能追加：
[現在のプロジェクト状況と追加したい機能を記載]
例：「Next.js + TypeScript + PostgreSQLで構築済みのECサイトに、
商品レビュー機能を追加したいです。
まず既存プロジェクトの情報を .ai/knowledge_base/ に移行してから、
機能追加を進めてください。」

まず既存コードベースを分析して .ai/knowledge_base/ に移行してから、
要件定義・実装を進めてください。"
```

**これだけで開発開始！** ✨

---

## 🔄 開発の流れ

### **🆕 新規プロジェクト開発フロー**

AIエージェントが自動的に以下を実行します：

#### **Phase 1: セットアップ・要件定義**
1. 🤖 リーダーエージェント初期化
2. 🎯 要件定義の対話的ヒアリング
3. 📊 YAML構造化データ作成（`.ai/knowledge_base/01_requirements_analysis/`）

#### **Phase 2: 設計・準備**
1. 🏗️ 基本設計の提案・調整
2. 📋 タスク分割・並列準備
3. 🧪 QAエージェント起動・テスト設計
4. 🌿 git worktree並列環境構築

#### **Phase 3: 実装**
1. 🤖 複数エンジニアエージェント起動
2. ⚡ TDD並列実装（Red-Green-Refactor）
3. 🔄 エージェント間通信・進捗管理

#### **Phase 4: 統合・完成**
1. ✅ PRレビュー・マージ
2. 🧪 統合テスト・E2Eテスト
3. 🚀 最終品質確認・本番準備

### **🔧 ai-framework導入済みプロジェクトの機能追加・改修フロー**

AIエージェントが自動的に以下を実行します：

#### **Phase 1: 既存情報確認・要件定義**
1. 🤖 リーダーエージェント初期化
2. 📊 既存 `.ai/knowledge_base/` の情報確認・理解
3. 🎯 機能追加・改修要件の対話的ヒアリング
4. 📋 既存機能への影響範囲分析
5. 📊 要件定義データ更新（`.ai/knowledge_base/01_requirements_analysis/`）

#### **Phase 2: 統合設計・準備**
1. 🏗️ 既存アーキテクチャに適合した設計提案
2. 📋 既存機能との整合性を考慮したタスク分割
3. 🧪 既存テストとの統合を考慮したテスト設計
4. 🌿 既存ブランチ戦略に適合したgit worktree環境構築

#### **Phase 3: 実装**
1. 🤖 複数エンジニアエージェント起動（既存コード理解済み）
2. ⚡ 既存コードとの整合性を保ったTDD実装
3. 🔄 既存機能への影響を監視しながらの進捗管理

#### **Phase 4: 統合・完成**
1. ✅ 既存機能への影響を考慮したPRレビュー・マージ
2. 🧪 既存機能との統合テスト・回帰テスト・E2Eテスト
3. 🚀 段階的リリース対応・本番準備

### **📦 ai-framework未導入プロジェクトの移行 + 機能追加フロー**

AIエージェントが自動的に以下を実行します：

#### **Phase 0: 既存プロジェクト移行**
1. 📊 既存コードベースの構造・技術スタック分析
2. 🔍 既存機能・API・データベース構造の把握
3. 📋 既存プロジェクト情報の `.ai/knowledge_base/` への移行
4. 🎯 既存アーキテクチャ・設計パターンの文書化

#### **Phase 1: 要件定義・影響分析**
1. 🤖 リーダーエージェント初期化（移行済み情報活用）
2. 🎯 機能追加・変更要件の対話的ヒアリング
3. 🔍 既存機能への影響範囲分析
4. 📊 要件定義データ作成（`.ai/knowledge_base/01_requirements_analysis/`）

#### **Phase 2以降**
- **🔧 ai-framework導入済みプロジェクトの機能追加・改修フロー** と同様

---

## 💡 ユーザーの役割

- **初期設定**: プロジェクト概要を伝える
- **要件確認**: AIエージェントの質問に答える
- **設計承認**: 技術選定・アーキテクチャの確認
- **最終確認**: ビジネスロジック・UX/UIの確認

**基本的にはAIエージェントが全て自動実行します！** 🎉

---

## 🧪 テスト設計・QA戦略Add commentMore actions

### **TDD並列実装フロー**

```mermaid
graph TD
    A[Step 3-1: タスク分割] --> B[Step 3-2: テスト設計・TDD準備]
    A --> C[Step 3-3: 並列環境構築]
    B --> D[Step 4: TDD並列実装開始]
    C --> D
    
    D --> E[🤖 Engineer Agent 1<br/>Red-Green-Refactor]
    D --> F[🤖 Engineer Agent 2<br/>Red-Green-Refactor]  
    D --> G[🤖 Engineer Agent 3<br/>Red-Green-Refactor]
    
    E --> H[🧪 QA Agent<br/>統合テスト設計]
    F --> H
    G --> H
    
    H --> I[Step 5: PRレビュー]
    I --> J[Step 6: マージ・統合]
    J --> K[Step 7: 統合テスト・E2E]
    K --> L[Step 8: 最終品質確認]
```

### **テスト設計の階層構造**

```mermaid
graph LR
    A[🧪 QA Agent] --> B[単体テスト設計]
    A --> C[統合テスト設計]  
    A --> D[E2Eテスト設計]
    A --> E[パフォーマンステスト設計]
    
    B --> F[🤖 Engineer Agent 1]
    B --> G[🤖 Engineer Agent 2]
    B --> H[🤖 Engineer Agent 3]
    
    F --> I[TDD実装<br/>Red-Green-Refactor]
    G --> I
    H --> I
    
    I --> J[PR作成・自動テスト実行]
    C --> K[統合テスト実行]
    D --> L[E2Eテスト実行]
    E --> M[パフォーマンステスト実行]
```

### **品質保証の段階別実行**

| 段階 | テスト種別 | 実行者 | 実行タイミング | 成功基準 |
|------|------------|--------|----------------|----------|
| **Phase 1** | 単体テスト | Engineer Agents | TDD実装中 | カバレッジ > 90% |
| **Phase 2** | 統合テスト | QA Agent | マージ後 | 全API連携成功 |
| **Phase 3** | E2Eテスト | QA Agent | 統合完了後 | 全ユーザーシナリオ成功 |
| **Phase 4** | パフォーマンステスト | QA Agent | 最終確認時 | 要件基準達成 |

---

## 🔄 更新・メンテナンス

```bash
# フレームワーク更新
git subtree pull --prefix ai-framework ai-framework-remote main --squash

# チーム同期
git pull

# 通信ファイルクリーンアップ
rm -f .ai/agent_communication/processed/*
```

---

## 🆘 トラブルシューティング

### **よくある問題**

**Q: エージェントが応答しない**
```bash
# 設定確認
cat .claude/settings.json
```

**Q: エージェント間通信が機能しない**
```bash
# 通信ディレクトリ確認
ls -la .ai/agent_communication/
# 権限確認
chmod 755 .ai/agent_communication/inbox/
chmod 755 .ai/agent_communication/outbox/
```

**Q: git worktreeでエラー**
```bash
# クリーンアップ
git worktree prune
```

**Q: subtree更新失敗**
```bash
# 強制更新
git subtree pull --prefix ai-framework ai-framework-remote main --squash --force
```

---

*このガイドで基本的な使用は可能です。詳細が必要な場合は各プロジェクトドキュメント（ai-framework/）を参照してください。*