# マルチエージェント役割定義書

## 🎯 概要

Claude Codeを活用し、実用性重視の効率的な並列開発を実現します。

## 🎭 エージェントチーム構成概要

本プロジェクトでは、プロジェクト要件に応じて柔軟にチーム構成できるマルチエージェント開発体制を構築します。

---

## 🎯 基本方針

### 効率的な並列開発アプローチ
- ファイルベース通信でシンプルな連携
- git worktreeによる独立した並列開発環境
- TDD統合による品質重視
- プロジェクト要件に応じた柔軟なチーム構成

---

## 👥 エージェントチーム構成

### 🎯 Leader Agent (統合リーダー)
**役割:** 要件整理・基本設計・統合指揮・進捗管理・品質保証

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
  - E2Eテスト・統合テスト指示
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
**役割:** 詳細設計・TDD実装・単体テスト・PR作成・自己品質保証

#### 🤖 エージェント設定
- **ツール**: Claude Code (multiple instances)
- **命名規則**: agent-{feature-task-name}
- **作業環境**: git worktree個別ディレクトリ
- **専門知識**: TDD、フルスタック実装、テスト設計、品質保証

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
    - 設計改善・リファクタリング

詳細設計調整:
  - 実装中の設計課題発見・対応
  - 基本設計の技術的制約への調整
  - コンポーネント間インターフェース詳細化
  - 実装知見に基づく設計改善提案

品質保証:
  - 単体テストカバレッジ確保（90%以上）
  - 統合テスト実装
  - コード品質チェック
  - 自己レビュー・品質確認

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

技術スタック（プロジェクトに応じて柔軟対応）:
  frontend:
    - プロジェクト要件に応じたWebフレームワーク
    - 型システム（TypeScript等）
    - CSS framework/library
    - フロントエンドテストフレームワーク
  
  backend:
    - プロジェクト要件に応じたバックエンドフレームワーク
    - 型システム（TypeScript等）
    - データベース（SQL/NoSQL）
    - バックエンドテストフレームワーク
  
  品質管理:
    - コードフォーマッター・リンター
    - Git hooks（pre-commit等）
    - CI/CDパイプライン
    - テストカバレッジツール
```

#### 📊 共通成果物
```yaml
実装成果物:
  - 機能実装コード（TDD準拠）
  - 包括的テストスイート（単体・統合）
  - PR（テスト・ドキュメント含む）
  - 実装ドキュメント

通信・連携:
  - 進捗報告YAMLファイル
  - 設計課題・相談YAMLファイル
  - インターフェース変更通知
  - 依存関係要請・報告

品質保証:
  - テストレポート
  - 品質チェック結果
  - パフォーマンステスト結果
```

## 🎯 品質保証プロセス

### 📊 品質管理レベル
```yaml
Level1_個別実装品質:
  owner: "各エンジニアエージェント"
  scope: "担当機能の個別品質保証"
  activities:
    - 単体テストカバレッジ90%以上
    - コード品質チェック
    - 自己レビュー実施
    - PR作成時の品質確認

Level2_統合品質管理:  
  owner: "LEADERエージェント"
  scope: "システム全体の品質統合"
  activities:
    - PRレビュー・承認
    - 統合テスト計画・実行
    - E2Eテスト実施
    - 品質ゲート管理
```

### 🔄 品質保証フロー
```yaml
実装フェーズ:
  1. "エンジニア: TDD実装"
  2. "エンジニア: 自己品質チェック"
  3. "エンジニア: PR作成"

統合フェーズ:
  4. "LEADER: PRレビュー"
  5. "LEADER: 統合テスト指示"
  6. "LEADER: マージ承認"

最終フェーズ:
  7. "LEADER: E2Eテスト実行"
  8. "LEADER: 最終品質判定"
  9. "LEADER: リリース承認"
```

---

## 📈 効率化のポイント

### 🚀 並列開発の最適化
- **独立性の確保**: git worktreeによる完全分離環境
- **依存関係の最小化**: API仕様先行確定
- **通信の効率化**: 必要最小限の業務通信のみ

### 🎯 品質とスピードの両立
- **TDD**: Red-Green-Refactorサイクル
- **自動化**: CI/CD・自動テスト・品質チェック
- **段階的統合**: 機能完了次第の逐次マージ

---

## 🔗 関連ドキュメント
- **通信システム**: 05_practical_agent_communication_system.md
- **ワークフロー**: 04_multi_agent_operational_workflow.md