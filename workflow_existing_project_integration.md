# 既存プロジェクト統合ワークフロー

## 🎯 概要
既存プロジェクトへのai-framework導入と機能追加・改修のワークフロー。
新規プロジェクトとは異なる統合・影響分析が必要。

---

## 🔧 ai-framework導入済みプロジェクトの機能追加・改修ワークフロー

### **A-1. 既存情報確認・要件定義** 👤➡️🤖
```yaml
参加者: ユーザー ↔ リーダーエージェント (Claude Code)
ツール: Claude Code (extracted thinking model)
トリガー: ai-framework導入済みプロジェクトの機能追加・改修要求

workflow:
  1. 既存 .ai/knowledge_base/ の情報確認・理解
  2. 既存プロジェクト構造・技術スタック・アーキテクチャの把握
  3. ユーザーからの機能追加・改修要求の整理
  4. 既存機能への影響範囲分析
  5. 既存システムとの整合性を考慮した要件定義
  6. 要件定義データの更新

execution_details:
  existing_knowledge_review:
    - .ai/knowledge_base/01_requirements/ の既存要件確認
    - .ai/knowledge_base/02_architecture/ の既存設計確認
    - 既存機能・API・データベース構造の理解
    - 既存テスト戦略・品質基準の確認
  
  impact_analysis:
    - 機能追加・変更による既存機能への影響評価
    - 既存API・データベーススキーマへの影響確認
    - 既存ユーザーへの影響最小化戦略
    - 段階的リリース要件の定義
  
  completion_action:
    - 既存プロジェクト対応を含む要件定義書を更新

deliverables:
  - 更新された要件定義書 (.ai/knowledge_base/01_requirements/)
  - 機能追加・改修GitHub Issues
  - 既存機能への影響評価書
  - 受け入れ基準（GitHub Issues内に記載）
```

### **A-2. 統合設計** 🤖➡️👤
```yaml
参加者: リーダーエージェント → ユーザーレビュー
トリガー: ユーザーの統合設計指示

workflow:
  1. 既存技術スタック・アーキテクチャとの整合性確認
  2. 既存システムに適合した設計提案
  3. 既存データベースとの統合設計
  4. 既存APIとの整合性を保った仕様設計
  5. 既存テスト環境を考慮したE2Eテスト設計・テストシナリオ策定
  6. 既存システムへの影響を考慮したユーザーレビュー・承認

execution_details:
  existing_system_integration:
    - 既存アーキテクチャパターンとの整合性確保
    - 既存データベーススキーマとの統合設計
    - 既存API仕様との互換性確保
    - 既存コーディング規約・設計パターンの踏襲
  
  existing_e2e_test_integration:
    - 既存テスト環境・テストツールとの統合設計
    - 既存E2Eテストとの競合回避・統合戦略
    - 新機能と既存機能の連携テストシナリオ作成
    - 既存テストデータ・フィクスチャとの整合性確保
    - 既存CI/CDパイプラインとの統合テスト戦略
  
  completion_action:
    - 既存プロジェクトとの整合性を確保した設計書を提出

deliverables:
  - 統合設計書
  - API仕様書 (OpenAPI) - 既存APIとの統合仕様含む
  - データベーススキーマ（既存スキーマとの統合設計含む）
  - 既存システム統合設計書
  - E2Eテスト統合設計書・テストシナリオ仕様書
```

### **A-3以降**
```yaml
workflow_continuation:
  - A-3以降は新規プロジェクトのPhase 2以降と同様のフローを実行
  - 既存システムとの整合性を保ちながら、タスク分割→実装→テスト→統合を実行
  - workflow_phase_2_task_breakdown.md から開始
```

---

## 📦 ai-framework未導入プロジェクトの移行 + 機能追加ワークフロー

### **M-0. 既存プロジェクト移行** 🤖
```yaml
参加者: リーダーエージェント (Claude Code)
トリガー: ai-framework未導入プロジェクトの移行 + 機能追加要求

workflow:
  1. 既存コードベースの構造・技術スタック分析
  2. 既存機能・API・データベース構造の把握
  3. 既存プロジェクト情報の .ai/knowledge_base/ への移行
  4. 既存アーキテクチャ・設計パターンの文書化
  5. 既存テスト戦略・品質基準の文書化

execution_details:
  codebase_migration:
    - プロジェクト構造・ディレクトリ構成の分析・文書化
    - 技術スタック・依存関係の把握・記録
    - 既存API仕様・エンドポイントの理解・文書化
    - データベーススキーマ・モデル構造の分析・記録
    - 既存テストコード・品質基準の確認・文書化
  
  architecture_documentation:
    - システムアーキテクチャパターンの識別・文書化
    - コンポーネント間の依存関係分析・記録
    - 設計パターン・コーディング規約の把握・文書化
    - パフォーマンス・セキュリティ要件の理解・記録
  
  completion_action:
    - 既存プロジェクト移行完了報告・機能追加フェーズへ移行

deliverables:
  - 既存プロジェクト分析レポート (.ai/knowledge_base/01_requirements/)
  - 技術スタック・アーキテクチャ図
  - 既存API仕様書
  - 既存データベーススキーマ文書
  - 既存テスト戦略文書
```

### **M-1以降**
```yaml
workflow_continuation:
  - M-1以降は「ai-framework導入済みプロジェクトの機能追加・改修ワークフロー」のA-1以降と同様
  - 移行済みの .ai/knowledge_base/ 情報を活用して機能追加・改修を実行
```

---

## 🔗 関連ドキュメント
- **新規プロジェクト**: 06_multi_agent_operational_workflow.md
- **フェーズ別ワークフロー**: workflow_phase_1_requirements_design.md 以降
- **通信システム**: 08_practical_agent_communication_system.md 