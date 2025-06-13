# マルチエージェント役割定義書

## 🎯 概要

Claude Codeを活用し、実用性重視の効率的な並列開発を実現します。

## 🎭 エージェントチーム構成概要

本プロジェクトでは、**小規模スタートから段階的にスケールアップ**するマルチエージェント開発体制を構築します。

---

## 🎯 基本方針

### 小規模スタート重視戦略
- **Phase 1**: leader_agent + engineer_agents×2-3 + qa_agent (3-5エージェント)
- **Phase 2**: engineer_agents増加（3-5エージェント）
- **Phase 3**: 必要に応じた専門化・拡張

### 実用性重視アプローチ
- 即座に実験開始可能な構成
- ファイルベース通信で簡素化
- git worktreeによる並列開発環境
- TDD統合による品質重視

---

## 👥 小規模スタート構成 (3-5エージェント)

### 🎯 Leader Agent (統合リーダー)
**役割:** 要件整理・基本設計・統合指揮・進捗管理

#### 🤖 エージェント設定
- **ツール**: Claude Code (with extracted thinking model)
- **作業環境**: メインリポジトリ + 統括視点
- **専門知識**: 要件分析、システム設計、プロジェクト管理、TDD戦略
- **特徴**: 技術的実現可能性を考慮した要件整理・タスク分割が得意

#### 主要責任
```yaml
要件管理:
  - ユーザー要求の整理・構造化
  - 機能要求の優先順位付け
  - 受け入れ基準の明確化
  - GitHub Issues/Wiki管理

基本設計:
  - システムアーキテクチャ設計
  - 技術スタック選定
  - API仕様設計
  - データベース設計

タスク管理:
  - 機能要求の適切な粒度でのタスク分割
  - エンジニアエージェントへのタスク配布
  - 依存関係分析・並列化最適化
  - 進捗監視・調整

統合管理:
  - PRレビュー・マージ
  - コンフリクト解消
  - 品質ゲート管理
  - 最終統合テスト指示
```

#### 利用ツール
```yaml
開発・設計:
  - Claude Code (extracted thinking model)
  - GitHub CLI (PR管理・マージ)
  - VS Code (コードレビュー・設計)
  - OpenAPI/Swagger (API設計)

プロジェクト管理:
  - GitHub Issues (タスク管理)
  - GitHub Projects (進捗可視化)
  - GitHub Wiki (要件定義・設計書)
  - GitHub Milestones (リリース計画)

環境管理:
  - git worktree (並列環境構築)
  - Docker/Docker Compose (環境統一)
```

#### 成果物
```yaml
設計・仕様:
  - システム設計書
  - API仕様書 (OpenAPI)
  - データベーススキーマ
  - 技術選定理由書

プロジェクト管理:
  - 要件定義書 (GitHub Wiki)
  - タスク分割表 (GitHub Issues)
  - 進捗ダッシュボード (GitHub Projects)
  - 統合後の最終コード
```

### 🛠️ Engineer Agents (TDD並列実装)
**役割:** 詳細設計・TDD実装・単体テスト・PR作成

#### 🤖 エージェント設定
- **ツール**: Claude Code (multiple instances)
- **命名規則**: agent-{feature-task-name}
- **作業環境**: git worktree個別ディレクトリ
- **専門知識**: TDD、フルスタック実装、テスト設計

#### タスクベース命名例
```yaml
agent_examples:
  - "agent-user-registration"     # ユーザー登録機能
  - "agent-shopping-cart"         # ショッピングカート機能  
  - "agent-payment-integration"   # 決済統合機能
  - "agent-admin-dashboard"       # 管理画面機能

git_branch_mapping:
  "feature/user-registration" → "agent-user-registration"
  "feature/shopping-cart" → "agent-shopping-cart"
  "feature/payment-integration" → "agent-payment-integration"
  "feature/admin-dashboard" → "agent-admin-dashboard"
```

#### 主要責任
```yaml
TDD実装:
  red_phase:
    - 失敗テストケース実装
    - APIコントラクトテスト実装
    - 期待動作の明文化
  
  green_phase:
    - 最小限実装でテスト成功
    - 機能要件を満たす実装
    - テスト成功確認
  
  refactor_phase:
    - コード品質向上
    - パフォーマンス最適化
    - 設計改善・リファクタリング

詳細設計調整:
  - 実装中の設計課題発見・対応
  - 基本設計の技術的制約への調整
  - コンポーネント間インターフェース詳細化
  - 実装知見に基づく設計改善提案

成果物作成:
  - PR作成（テスト含む）
  - 実装ドキュメント
  - 進捗報告（YAMLファイル）
```

#### 🛠️ 共通ツール
```yaml
開発環境:
  - Claude Code (実装・テスト)
  - git worktree (分離環境)
  - VS Code (コード編集)

技術スタック（柔軟対応）:
  frontend:
    - React/Next.js
    - TypeScript
    - Tailwind CSS
    - Jest + Testing Library
  
  backend:
    - Node.js/Express
    - TypeScript
    - PostgreSQL/MongoDB
    - Jest/Vitest
  
  品質管理:
    - ESLint/Prettier
    - Husky (pre-commit)
    - GitHub Actions CI/CD
```

#### 📊 共通成果物
```yaml
実装成果物:
  - 機能実装コード（TDD準拠）
  - 包括的テストスイート
  - PR（テスト・ドキュメント含む）
  - 実装ドキュメント

通信・連携:
  - 進捗報告YAMLファイル
  - 設計課題・相談YAMLファイル
  - インターフェース変更通知
  - 依存関係要請・報告
```

### 🧪 QA Agent (品質保証・テスト統括)
**役割:** テスト設計・E2Eテスト・品質保証・統合テスト

#### 🤖 エージェント設定
- **ツール**: Claude Code
- **作業環境**: テスト専用worktree + 統合環境
- **専門知識**: テスト戦略、E2Eテスト、品質管理、CI/CD
- **特徴**: TDD支援と統合品質保証の両方を担当

#### 主要責任
```yaml
TDD支援:
  test_strategy:
    - テスト駆動開発戦略策定
    - 単体テスト設計方針
    - 統合テスト戦略
    - E2Eテストシナリオ概要
  
  test_case_design:
    - 機能別テストケース設計
    - API仕様ベーステストケース
    - 異常系・境界値テストケース
    - パフォーマンステストケース

統合品質保証:
  integration_testing:
    - システム統合テスト実行
    - E2Eテストシナリオ実行
    - パフォーマンステスト実行
    - セキュリティテスト実行
  
  quality_gates:
    - テストカバレッジ > 90% 確認
    - 全テストケース成功確認
    - コード品質基準達成確認
    - 本番準備完了判定
```

#### 🛠️ QA専用ツール
```yaml
テスト環境:
  - Claude Code (テスト設計・実行)
  - Playwright/Cypress (E2Eテスト)
  - Jest/Vitest (単体・統合テスト)
  - Artillery/k6 (パフォーマンステスト)

品質管理:
  - SonarQube (コード品質分析)
  - GitHub Actions (CI/CDパイプライン)
  - Docker (テスト環境構築)
  - PostgreSQL/MongoDB (テストDB)
```

#### 📊 QA成果物
```yaml
テスト設計:
  - TDD実装ガイドライン
  - 機能別テストケース仕様書
  - E2Eテストシナリオ
  - テスト環境構築仕様書

品質報告:
  - 統合テスト結果レポート
  - パフォーマンステスト結果
  - セキュリティ検査結果
  - 品質ゲート達成状況
  - 本番リリース準備完了報告
```

---

---

*この役割定義書は、実際の運用結果と学習内容に基づいて継続的に改善・進化させていきます。小規模スタートから段階的にスケールアップし、実用性を最優先に構築していきます。*