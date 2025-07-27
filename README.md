# 🤖 AI駆動マルチエージェント開発フレームワーク

**小規模スタートから段階的にスケールアップ**するマルチエージェント開発システムの設計書・仕様書集

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Personal Learning](https://img.shields.io/badge/type-personal%20learning-brightgreen.svg)
![Status](https://img.shields.io/badge/status-active%20development-blue.svg)

## 🎯 概要

このリポジトリは、**Claude Code**を基盤とした実用的なマルチエージェント開発フレームワークの設計書・仕様書を管理しています。

> **⚠️ 個人用リポジトリ**: このリポジトリは個人的な学習・実験・知識整理を目的としており、他者への提供や汎用的な利用を前提としていません。内容は実践と学習に応じて**適宜更新・改変**されます。

### 🌟 特徴
- **📏 小規模スタート重視**: 3-5エージェントから開始、段階的拡張
- **⚡ 即座に実験開始可能**: 5分で環境構築完了
- **🔄 実用性優先**: オーバーエンジニアリング回避、ROI重視
- **🔧 TDD統合**: テスト駆動開発による品質保証
- **⚡ tmux直接通信**: リアルタイム協調システム
- **🤝 ブランチベース協調**: チームでの協調開発

---

## 📋 ドキュメント構成

### **📚 コアドキュメント（必読）**

| ドキュメント | 概要 | 対象者 | 優先度 |
|-------------|------|--------|--------|
| **[01_ai_driven_development_requirements.md](./01_ai_driven_development_requirements.md)** | AI駆動開発の要件定義・目的・期待効果 | 全員 | 🔥**最優先** |
| **[02_agent_role_definitions.md](./02_agent_role_definitions.md)** | エージェントの役割・責任・ツール構成 | 実装者 | 🔥**最優先** |
| **[04_multi_agent_operational_workflow.md](./04_multi_agent_operational_workflow.md)** | 運用ワークフロー・実践的実装手順 | 実装者 | 🔥**最優先** |

### **⚙️ 技術仕様書**

| ドキュメント | 概要 | 利用タイミング |
|-------------|------|----------------|
| **[03_knowledge_base_architecture.md](./03_knowledge_base_architecture.md)** | 知識ベース設計・情報管理 | Phase2〜（知識蓄積が必要な時） |

### **📖 その他**

| ドキュメント | 概要 |
|-------------|------|
| **[research.md](./research.md)** | 調査資料・参考文献・技術的背景 |
| **[logs/](./logs/)** | 開発過程の会話ログ・学習記録 |

---

## 📋 最初に読むべきドキュメント

1. **[01_ai_driven_development_requirements.md](./01_ai_driven_development_requirements.md)** - 🎯 なぜ・何を・どのようにAIを活用するか
2. **[02_agent_role_definitions.md](./02_agent_role_definitions.md)** - 👥 エージェントの役割分担・責任範囲
3. **[04_multi_agent_operational_workflow.md](./04_multi_agent_operational_workflow.md)** - 🔄 実際の運用手順・実装フロー
4. **[03_knowledge_base_architecture.md](./03_knowledge_base_architecture.md)** - 🧠 知識ベース管理・データ構造化方法

---

## 🚀 クイックスタート

**📖 詳細なセットアップ手順・開発フローについては [USAGE.md](./USAGE.md) を参照してください**

---

## 👥 エージェント構成

### **基本構成（4エージェント協業）**
- **architect** (pane 0): 設計・アーキテクト (25%)
- **engineer-1** (pane 1): 実装エンジニア (25%)
- **engineer-2** (pane 2): 実装エンジニア (25%)  
- **reviewer** (pane 3): コードレビュー・品質管理 (25%)

### **詳細役割**

#### **Architect Agent（設計・アーキテクト）**
- **ツール**: Claude Code
- **役割**: 要件分析・技術選定・アーキテクチャ設計・設計レビュー
- **環境**: メインリポジトリ + 設計ドキュメント管理

#### **Engineer Agents（実装エンジニア）**
- **ツール**: Claude Code (2 instances)
- **役割**: 実装・単体テスト作成・技術調査・PR作成
- **環境**: 共通ブランチでの協調作業

#### **Reviewer Agent（コードレビュー・品質管理）**
- **ツール**: Claude Code
- **役割**: コードレビュー・品質チェック・統合テスト・改善提案
- **環境**: 全ブランチアクセス + 品質基準管理

### **tmux通信システム**
- **セッション名**: `agents`
- **ペイン構成**: 4分割レイアウト
- **通信方式**: tmux直接通信による実時間協調
- **視覚識別**: 各ペインに名前設定で識別しやすい構成

## 📁 ディレクトリ構造

### **基本ディレクトリ構造**
```
~/projects/
├── ai_driven_development/         # フレームワーク本体（プロジェクト外部）
│   ├── scripts/           # スクリプト集
│   │   ├── setup-agent-communication.sh  # tmux環境構築
│   │   ├── start-agents.sh              # エージェント起動
│   │   ├── phase1-2-start.sh           # フェーズ1-2起動
│   │   ├── phase3-start.sh             # フェーズ3起動
│   │   ├── agent-send.sh               # 通信テスト
│   │   └── quick-start.sh              # ワンクリック実行
│   └── templates/         # テンプレート集
│       ├── architect_agent_setup_template.md
│       ├── engineer_agent_setup_template.md
│       └── reviewer_agent_setup_template.md
└── your-project/          # プロダクトコード
    ├── .ai-framework -> ../ai_driven_development  # シンボリックリンク
    ├── .claude/               # Claude Code設定
    │   └── settings.json               # 実際の設定（gitignore推奨）
    ├── .ai/
    │   ├── tasks/                  # タスク管理（ファイルベース）
    │   │   ├── task_list.md           # タスク一覧
    │   │   └── task_XXX.md            # 個別タスク詳細
    │   └── logs/                   # 開発記録・通信ログ
    │       ├── communication.log      # 通信ログ
    │       └── communication.lock     # 通信ロックファイル
    └── src/                   # プロダクトコード
```

---

## 🎨 プロジェクト固有カスタマイズ

### **フレームワーク更新**
```bash
# フレームワーク更新
cd ../ai_driven_development
git pull origin main

# プロジェクトに戻る
cd ../your-project

# 通信ファイルクリーンアップ
rm -f .ai/agent_communication/processed/*
```

---

## 🔄 開発フロー

**詳細な開発手順・プロンプト例・トラブルシューティングは [USAGE.md](./USAGE.md) を参照してください**

### **基本的な流れ**
1. 🚀 **開始**: `@.ai-framework/templates/architect_agent_setup_template.md` でアーキテクトエージェント起動
2. 🎯 **要件定義**: 対話的ヒアリングで要件整理
3. 🏗️ **設計**: 技術選定・アーキテクチャ設計
4. ⚡ **実装**: エンジニアによる協調実装
5. ✅ **完成**: レビュー・統合テスト・品質確認

---

## 📄 ライセンス

MIT License - 自由に利用・改変・再配布可能

## 🔗 関連リンク

- **[Claude](https://claude.ai/)**: AIエージェント
- **[MCP Protocol](https://modelcontextprotocol.io/)**: ツール統合プロトコル

**🌟 Star this repo if you find it helpful!** 