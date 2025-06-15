# 🧠 AI-First 知識ベースアーキテクチャ

## 📚 知識ベース概要

AIエージェントの「長期記憶」と「共有知」として機能する知識ベースを設計します。
各エージェントが一貫した情報にアクセスし、効率的なコラボレーションを実現するための基盤となります。

---

## 🏗️ プロジェクトタイプ別運用戦略

### 🆕 新規プロジェクト: AI-First YAML主導アーキテクチャ

#### 基本方針: AI-Driven Knowledge Management
- **AI最優先**: YAML構造化データをマスターソースとして管理
- **構造化重視**: AIエージェントの処理効率を最大化
- **セマンティック最適化**: 機械学習・自然言語処理に最適化された形式
- **一貫性保証**: 構造化データによる品質・整合性の自動保証
- **シンプル管理**: 単一ソース（.ai/knowledge_base/）による統一管理

#### AI-First アーキテクチャ
```
.ai/ (Knowledge Base Root)
└── knowledge_base/                   # AI主導層（統一管理）
    ├── 01_requirements/              # YAML構造化要件データ
    ├── 02_architecture/              # YAML技術アーキテクチャ
    ├── 03_development/               # YAML 開発標準・規約
    └── 04_quality/                   # YAML 品質保証設定
```

### 🔄 既存プロジェクト: 補完型知識ベース活用

#### 基本方針: Existing-First Complementary Approach
- **既存ドキュメント最優先**: 既存の仕様書・設計書・READMEを主要情報源として活用
- **補完的活用**: 知識ベースは抜け漏れチェック・参考情報として利用
- **段階的改善**: 既存ドキュメントを徐々に改修・構造化
- **柔軟な情報源**: プロジェクト固有のドキュメント構造に適応
- **最小限導入**: 必要最小限の知識ベース要素のみ導入

#### 既存プロジェクト対応アーキテクチャ
```
既存プロジェクト/
├── 既存ドキュメント/                  # メイン情報源（優先参照）
│   ├── README.md
│   ├── docs/
│   ├── 設計書.*
│   └── API仕様書.*
│
└── .ai/ (Optional補完)               # 補完的知識ベース
    └── knowledge_base/               # 参考・チェック用
        ├── project_checklist.yaml   # 抜け漏れチェック用
        ├── best_practices.yaml      # 開発ベストプラクティス
        └── quality_guidelines.yaml  # 品質ガイドライン
```

#### 既存プロジェクト運用原則
- **情報参照順序**: 既存ドキュメント → 知識ベース（補完）
- **更新方針**: 既存ドキュメントを改修、知識ベースは参考として活用
- **抜け漏れ防止**: 知識ベースをチェックリストとして活用
- **段階的移行**: 必要に応じて既存ドキュメントを徐々に構造化

---

## 📂 新規プロジェクト用: AI-First カテゴリ設計

### 01_requirements/ - 要件・仕様

#### 📄 AI主導ファイル構成 (.ai/knowledge_base/01_requirements/)
```
.ai/knowledge_base/01_requirements/
├── project_overview.yaml           # プロジェクト概要
├── user_stories.yaml               # ユーザーストーリー
├── functional_specs.yaml           # 機能仕様
├── acceptance_criteria.yaml        # 受け入れ基準
└── business_rules.yaml             # ビジネスルール
```

**管理責任**: LEADERエージェント

### 02_architecture/ - 技術アーキテクチャ

#### 📄 AI主導ファイル構成 (.ai/knowledge_base/02_architecture/)
```
.ai/knowledge_base/02_architecture/
├── system_design.yaml              # システム設計
├── technology_stack.yaml           # 技術スタック
├── api_specifications.yaml         # API仕様
├── database_design.yaml            # データベース設計
└── deployment_config.yaml          # デプロイメント構成
```

**管理責任**: LEADERエージェント + エンジニアエージェント

### 03_development/ - 開発標準・規約

#### 📄 AI主導ファイル構成 (.ai/knowledge_base/03_development/)
```
.ai/knowledge_base/03_development/
├── coding_standards.yaml           # コーディング規約
├── git_workflow.yaml               # Git ワークフロー
├── development_setup.yaml          # 開発環境セットアップ
├── code_review_process.yaml        # コードレビュープロセス
└── troubleshooting.yaml            # トラブルシューティング
```

**管理責任**: エンジニアエージェント

### 04_quality/ - 品質保証・テスト

#### 📄 AI主導ファイル構成 (.ai/knowledge_base/04_quality/)
```
.ai/knowledge_base/04_quality/
├── test_strategy.yaml              # テスト戦略
├── quality_standards.yaml          # 品質基準
├── test_cases.yaml                 # テストケース
├── automation_config.yaml          # テスト自動化設定
└── bug_reports.yaml                # バグレポート
```

**管理責任**: QAエージェント

---

## 📂 既存プロジェクト用: 補完型知識ベース

### 最小限知識ベース構成
```yaml
# project_checklist.yaml - 抜け漏れチェック用
version: "1.0"
checklist_categories:
  requirements:
    - user_stories_documented: "ユーザーストーリーが文書化されているか"
    - acceptance_criteria_defined: "受け入れ基準が明確か"
    
  architecture:
    - system_design_documented: "システム設計が記載されているか"
    - api_specs_available: "API仕様書が存在するか"
    
  development:
    - coding_standards_defined: "コーディング規約が定義されているか"
    - git_workflow_documented: "Gitワークフローが明文化されているか"
    
  quality:
    - test_strategy_defined: "テスト戦略が定義されているか"
    - quality_gates_established: "品質ゲートが設定されているか"
```

---

## 🤖 YAML構造化データ例（新規プロジェクト用）

```yaml
# user_stories.yaml
version: "1.0"
last_updated: "2024-12-29T10:00:00Z"

stories:
  - id: "US001"
    title: "ユーザー登録機能"
    priority: "high"
    status: "approved"
    
    narrative:
      as: "新規ユーザー"
      want: "メールアドレスとパスワードでアカウントを作成したい"
      so_that: "サービスを利用開始できる"
    
    acceptance_criteria:
      - description: "有効なメールアドレス形式でのみ登録可能"
      - description: "パスワードは8文字以上で英数字記号混在"
    
    tags: ["authentication", "mvp", "user_management"]
```

---

## 🔄 プロジェクトタイプ別データ管理システム

### 新規プロジェクト: YAML構造化データ管理
```yaml
データ管理プロセス:
  1. YAML構造化データの直接更新
  2. スキーマバリデーション・品質チェック
  3. AIエージェント間のデータ共有・同期

管理規則:
  - YAML metadata による構造化管理
  - 関係性データによるクロスリファレンス
  - AIエージェント直接アクセス最適化
```

### 既存プロジェクト: 補完型データ管理
```yaml
データ参照プロセス:
  1. 既存ドキュメント優先参照
  2. 知識ベースで抜け漏れチェック
  3. 必要に応じて既存ドキュメント改修

管理規則:
  - 既存情報源を尊重・活用
  - 知識ベースは参考・補完として利用
  - 段階的な構造化・改善
```

### 共通品質保証システム
```yaml
自動品質チェック:
  - 情報の一貫性確認（新規：YAML、既存：ドキュメント）
  - 抜け漏れ検出
  - 依存関係検証

品質管理:
  - プロジェクトタイプに応じた柔軟な管理
  - AIアクセス効率最適化
  - 知識ベース完全性チェック
```