# マルチエージェント実運用ワークフロー仕様書

## 🎯 概要

Claude Codeを活用したマルチエージェント開発体制の実用的な運用フローを定義します。
git worktreeによる並列開発環境とユーザートリガー制御により、安全で効率的な協業を実現します。
将来的にはACPへの移行も検討。

---

## 🏗️ システム構成

### **エージェント構成**
```yaml
leader_agent:
  tool: "Claude Code"
  role: "統合指揮・要件整理・基本設計・進捗管理・タスク分配"
  
engineer_agents:
  tool: "Claude Code (multiple instances)"
  role: "詳細設計・実装・単体テスト・PR作成"
  fixed_configuration:
    - "engineer-1"     # 汎用エンジニアエージェント1
    - "engineer-2"     # 汎用エンジニアエージェント2
  dynamic_assignment:
    - LEADERからのタスク分配に応じて担当機能を決定
    - 各エージェントが必要に応じてgit worktree環境を作成
    - 複数機能を並行して担当可能
  
qa_agent:
  tool: "Claude Code"
  role: "E2Eテスト設計・実装"
```

### **開発環境構成**
```bash
# エージェント環境（事前構築済み）
# ./ai-framework/scripts/quick-start.sh または ./ai-framework/scripts/setup-agent-communication.sh + ./ai-framework/scripts/start-agents.sh で構築

tmux session: agents
├── pane 0: LEADER (👑 プロジェクト管理・タスク分配)
├── pane 1: engineer-1 (💻 汎用エンジニア・待機中)
├── pane 2: engineer-2 (🖥️ 汎用エンジニア・待機中)
├── pane 3: engineer-3 (⚙️ 汎用エンジニア・待機中)
└── pane 4: qa-agent (🧪 E2Eテスト設計・実装)

# メインリポジトリ
main-repo/
├── main branch (統合ブランチ)
├── feature branches (機能ブランチ - 動的作成)
└── worktrees/ (並列作業環境 - 動的作成)
    ├── ../feature-auth/                  # engineer-1が作成・担当
    ├── ../feature-data-management/       # engineer-2が作成・担当
    ├── ../feature-api-integration/       # engineer-1が追加作成・担当
    └── ../feature-ui-components/         # engineer-2が追加作成・担当

# 動的タスク分配の例（エージェント起動済み前提）
dynamic_task_assignment:
  task_distribution_phase:
    - LEADER → engineer-1: "機能A（例：認証機能）を担当してください"
    - LEADER → engineer-2: "機能B（例：データ管理機能）を担当してください"
    - engineer-1: git worktree add ../feature-auth feature/auth
    - engineer-2: git worktree add ../feature-data-management feature/data-management
  
  parallel_execution_phase:
    - engineer-1: feature/auth ブランチで作業
    - engineer-2: feature/data-management ブランチで作業
    - 必要に応じて追加タスクを動的分配
```

---

## 🔄 運用ワークフロー

### **🆕 新規プロジェクト開発ワークフロー**

#### **Phase 1: 要件定義・基本設計**

##### **1-1. 要求整理・要件定義** 👤➡️🤖
```yaml
参加者: ユーザー ↔ リーダーエージェント (Claude Code)
ツール: Claude Code (extracted thinking model)
トリガー: ユーザーの新規プロジェクト開始

workflow:
  1. ユーザーが要求を自然言語で説明
  2. リーダーエージェントが要件を整理・構造化
  3. 要件定義書のドラフト作成
  4. ユーザーとの対話による要件の精緻化
  5. 最終要件定義書の確定

deliverables:
  - 要件定義書 (.ai/knowledge_base/01_requirements/)
  - 機能要求一覧 (GitHub Issues)
  - 受け入れ基準 (GitHub Issues)
```

##### **1-2. 基本設計・テスト戦略策定** 🤖➡️👤
```yaml
参加者: リーダーエージェント → ユーザーレビュー
トリガー: ユーザーの基本設計指示

workflow:
  1. 要件定義に基づく技術スタック選定
  2. システムアーキテクチャ設計
  3. データベース設計
  4. API仕様設計
  5. テスト駆動開発戦略の策定
  6. 単体テスト設計方針の策定
  7. ユーザーレビュー・承認

test_strategy_design:
  tdd_strategy:
    - テスト駆動開発戦略の策定
    - 単体テスト設計方針
    - テストファースト原則の定義
    - テストカバレッジ基準設定
  
  unit_test_guidelines:
    - 機能別単体テスト方針
    - API仕様に基づくテスト設計
    - 異常系・境界値テスト方針
    - モック・スタブ利用方針

deliverables:
  - システム設計書
  - API仕様書 (OpenAPI)
  - データベーススキーマ
  - 技術選定理由書
  - TDD実装ガイドライン
  - 単体テスト設計方針書
```

#### **Phase 2: タスク分割・E2Eテスト設計**

##### **2-1. タスク分割・GitHub Issues作成** 🤖
```yaml
参加者: リーダーエージェント
トリガー: ユーザーのタスク分割指示

前提条件:
  - エージェント環境は既に起動・待機状態
  - ./ai-framework/scripts/quick-start.sh または ./ai-framework/scripts/setup-agent-communication.sh + ./ai-framework/scripts/start-agents.sh で構築済み

workflow:
  1. 機能要求を親タスクに分割
  2. 親タスクを適度な粒度の子タスクに分解
  3. タスク間の依存関係を分析
  4. 並列実行可能なタスクを特定
  5. タスク優先度付け
  6. 各タスクをGitHub Issuesとして作成

github_issues_creation:
  issue_template:
    - タイトル: 機能名・タスク概要
    - 説明: 詳細な要件・受け入れ基準
    - ラベル: 機能分類・優先度・担当領域
    - マイルストーン: リリース予定
    - 依存関係: 関連Issue番号
  
  issue_examples:
    - "Issue #1: ユーザー認証API実装"
    - "Issue #2: データ管理CRUD機能実装"
    - "Issue #3: API統合・外部連携機能実装"
    - "Issue #4: E2Eテスト実装"

execution_details:
  task_breakdown_process:
    - 機能要求を並列実行可能なタスクに分割
    - タスク間の依存関係を分析・整理
    - タスク優先度付け
    - 各タスクをGitHub Issueとして作成
    - 実装スケジュール作成
  
  completion_action:
    - 作成されたGitHub Issues一覧をエンジニアエージェントに共有
    - E2Eテスト設計とのタスク分割結果を共有

deliverables:
  - GitHub Issues（各タスク）
  - 依存関係図
  - 実装スケジュール
  - Issue番号一覧表
```

##### **2-2. E2Eテスト設計・実装** 🤖 ⚡ 並列実行
```yaml
参加者: QAエージェント (Claude Code)
トリガー: 基本設計完了・ユーザーのE2Eテスト設計指示

前提条件:
  - QAエージェントは既に起動・待機状態
  - ai-framework/templates/qa_agent_setup_template.md の指示書読み込み済み

e2e_test_design:
  test_scenario_design:
    - ユーザーシナリオベースのE2Eテスト設計
    - 機能間連携テストシナリオ
    - 異常系・エラーハンドリングテスト
    - パフォーマンス・負荷テストシナリオ
  
  test_implementation:
    - E2Eテストコードの実装
    - テストデータ・フィクスチャの作成
    - テスト環境セットアップスクリプト
    - CI/CD統合用テストスクリプト
  
  test_automation_setup:
    - ブラウザ自動化テスト環境構築
    - API統合テスト環境構築
    - テスト実行・レポート生成システム
    - CI/CDパイプライン統合設定

execution_details:
  implementation_tasks:
    - ユーザーシナリオベースのE2Eテスト設計・実装
    - テストデータ・環境セットアップ
    - CI/CD統合用テストスクリプト作成
    - テスト実行・レポート生成システム構築
  
  completion_action:
    - E2Eテスト実装完了・CI統合準備完了を報告

deliverables:
  - E2Eテストシナリオ仕様書
  - E2Eテストコード（実装済み）
  - テストデータセット・フィクスチャ
  - テスト環境構築スクリプト
  - CI/CD統合用テストスクリプト
```

#### **Phase 3: 動的タスク分配・TDD並列実装**

##### **3-1. GitHub Issues割り当て・環境構築** 🤖➡️🤖🤖
```yaml
参加者: LEADERエージェント → エンジニアエージェント
トリガー: GitHub Issues作成完了・ユーザーのタスク分配開始指示

前提条件:
  - 全エージェントが既に起動・待機状態
  - LEADERエージェント: GitHub Issues作成完了・タスク分配準備完了
  - engineer-1, engineer-2: 汎用エンジニア・タスク分配待ち
  - qa-agent: E2Eテスト設計・実装準備完了

github_issues_assignment:
  issue_assignment_process:
    - LEADERが作成されたGitHub IssuesをエンジニアエージェントにAssign
    - 各エンジニアエージェントにIssue番号を指定して担当指示
    - エンジニアエージェントがGitHub Issueを確認・受諾
    - 必要に応じてIssue内容の詳細確認・調整
  
  worktree_environment_creation:
    - 各エンジニアエージェントが担当Issue用のgit worktree環境を作成
    - Issue番号ベースのブランチ作成・チェックアウト
    - 作業ディレクトリでの開発環境セットアップ

  environment_isolation_setup:
    - 環境変数・設定ファイルの個別管理
    - データベース接続・ポート番号の分離設定
    - テスト実行環境の個別構築

execution_examples:
  leader_issue_assignment:
    - "engineer-1への指示: Issue #1（ユーザー認証API実装）を担当してください"
    - "engineer-2への指示: Issue #2（データ管理CRUD機能実装）を担当してください"
    - "qa-agentへの指示: Issue #4（E2Eテスト実装）を担当してください"
  
  engineer_environment_setup:
    - engineer-1: "git worktree add ../issue-1-auth feature/issue-1-auth"
    - engineer-2: "git worktree add ../issue-2-data-management feature/issue-2-data-management"
    - 各エージェント: GitHub Issue内容確認・作業ディレクトリでの環境セットアップ実行

github_workflow_integration:
  - Issue番号ベースのブランチ命名（feature/issue-{number}-{description}）
  - コミットメッセージにIssue番号を含める（"Fix #1: 認証API実装"）
  - PR作成時にIssue番号を自動リンク
  - Issue完了時の自動クローズ設定
  
  completion_action:
  - 各エンジニアエージェントのIssue確認・環境構築完了確認
  - TDD並列実装開始準備完了報告
```

##### **3-2. TDD並列実装実行** 🤖⚡🤖⚡
```yaml
参加者: エンジニアエージェント (複数Claude Code)
トリガー: 動的タスク分配・環境構築完了

execution_workflow:
  implementation_steps:
    - 各エンジニアエージェントが担当機能のworktree環境で作業開始
    - TDD（Red-Green-Refactor）サイクルでの実装
    - リアルタイム直接通信による協調・質疑応答
    - 進捗・課題の即座共有・解決

agent_communication_management:
  direct_communication_protocol:
    - LEADERが各エージェントに直接指示送信
    - エージェント間での即座の質疑応答・情報共有
    - 問題発生時の即座エスカレーション・解決
    - 進捗・完了報告の直接通知
  
  communication_examples:
    leader_to_engineers: "engineer-1への指示: [具体的な実装タスク]"
    engineer_to_engineer: "engineer-2への連絡: [API仕様について]"
    engineer_to_qa: "qa-agentへの連絡: [実装完了、テストお願いします]"
    qa_to_leader: "LEADERへの報告: [テスト完了、品質基準達成]"
  
  completion_action:
    - LEADERから各エージェントへの開始指示を直接送信
    - 並列TDD実装をリアルタイム監視で開始

tdd_workflow:
  red_phase:
    - テストケース実装（失敗テスト作成）
    - APIコントラクトテスト実装
    - 期待する動作の明文化
  
  green_phase:
    - 最小限の実装でテストを通す
    - 機能要件を満たすコード実装
    - テスト成功の確認
  
  refactor_phase:
    - コード品質向上
    - パフォーマンス最適化
    - 設計改善・リファクタリング

  detailed_design_refinement:
    - 実装中の詳細設計課題発見・調整
    - 基本設計では見えなかった技術的制約への対応
    - コンポーネント間インターフェースの詳細化
    - パフォーマンス・セキュリティ観点での設計調整
    - 実装知見に基づく設計改善提案

parallel_tdd_execution:
  engineer-1_assigned_tasks:
    - 担当Issue: Issue #1（ユーザー認証API実装）
    - 作業環境: ../issue-1-auth/ worktree
    - 実装内容:
      * GitHub Issue要件に基づく認証APIテスト実装
      * バリデーション・セキュリティロジック実装
      * 権限チェック・セッション管理テスト実装
      * 実装中の認証フロー詳細設計調整
    - 成果物: PR作成（Issue #1リンク・テスト含む）
  
  engineer-2_assigned_tasks:
    - 担当Issue: Issue #2（データ管理CRUD機能実装）
    - 作業環境: ../issue-2-data-management/ worktree
    - 実装内容:
      * GitHub Issue要件に基づくデータCRUD操作テスト実装
      * データベース連携・バリデーションテスト
      * データ整合性・パフォーマンステスト実装
      * 実装中のデータモデル詳細設計調整
    - 成果物: PR作成（Issue #2リンク・テスト含む）
  
  additional_issue_assignment:
    - 必要に応じてengineer-1, engineer-2に追加Issueを分配
    - 例: engineer-1にIssue #3（API統合機能）を追加分配
    - 各エージェントが複数Issue・worktree環境で並行作業可能

design_coordination:
  real_time_communication:
    - 実装中の設計課題・変更提案の即座共有
    - 他エージェントへの影響評価・調整
    - 共通コンポーネント・インターフェース変更の協議
  
  design_update_process:
    - 重要な設計変更はリーダーエージェントに報告
    - ユーザー判断が必要な場合の適切なエスカレーション
    - 設計変更の文書化・共有

quality_gates:
  - テストファースト原則の遵守
  - 全テストケース成功
  - コード品質チェック（ESLint/Prettier）
  - TypeScript型安全性確保
  - 実装中の設計調整の適切な文書化
```



#### **Phase 4: レビュー・統合・完了**

##### **4-1. PRレビュー** 👤🤖
```yaml
参加者: ユーザー・リーダーエージェント
トリガー: エンジニアエージェントのPR作成完了通知

execution_details:
  automated_checks:
    - 全単体テストケース実行・成功確認
    - コード品質チェック（ESLint/Prettier）
  
  leader_agent_review:
    - TDD原則遵守確認
    - 単体テストケース品質評価
    - 実装とテストの整合性確認
    - リファクタリング品質評価
  
  user_review_items:
    - ビジネスロジックの正確性確認
    - 受け入れ基準の達成確認
    - UX/UI の確認（該当する場合）
    - API仕様変更の妥当性（該当する場合）
    - データベーススキーマ変更の妥当性（該当する場合）
  
  completion_action:
    - ユーザーレビューが必要な項目を整理して報告
    - ユーザー確認完了後: "レビュー完了しました。マージを実行してください。"

review_criteria:
  auto_approve:
    - 全単体テスト成功
    - 軽微なリファクタリング
  
  user_review_required:
    - 新機能追加
    - APIの変更
    - データベーススキーマ変更
    - ビジネスロジックの変更
```

##### **4-2. マージ・コンフリクト解消** 🤖
```yaml
参加者: リーダーエージェント
トリガー: ユーザーのレビュー完了

execution_details:
  merge_pre_checks:
    - マージ前の単体テスト実行
    - テスト競合の自動解決
    - テストデータ統合・調整
  
  conflict_resolution_strategy:
    - テストケース競合の優先度判定
    - 実装競合の自動調整
    - 複雑な競合はエージェント間協議で解決
  
  post_merge_actions:
    - 単体テストスイート実行
    - 回帰テスト実行
    - E2Eテスト実行準備（CI/ユーザー実行用）
  
  completion_action:
    - 統合結果を報告
    - E2Eテスト・統合テストはCI/ユーザー実行に移行
```

##### **4-3. 開発完了・引き渡し** 🤖➡️👤
```yaml
参加者: リーダーエージェント → ユーザー
トリガー: マージ完了

execution_details:
  deliverable_summary:
    - 実装機能の完了報告
    - 単体テスト結果サマリー
    - E2Eテストコード・実行手順の提供
    - CI/CD統合準備完了報告
  
  handover_materials:
    - 実装コード（マージ済み）
    - 単体テストコード・結果
    - E2Eテストコード・実行スクリプト
    - API仕様書・ドキュメント更新
    - 環境構築・デプロイ手順書
  
  next_steps_guidance:
    - E2Eテスト・統合テスト実行方法
    - CI/CDパイプライン実行手順
    - 本番デプロイ準備チェックリスト
  
  completion_action:
    - 開発フェーズ完了・ユーザーへの引き渡し完了報告

note:
  - 統合テスト・E2EテストはユーザーまたはCI環境で実行
  - 本番準備・品質確認はユーザー責任範囲
  - エージェント開発フェーズはここで完了
```

---

### **🔧 ai-framework導入済みプロジェクトの機能追加・改修ワークフロー**

#### **A-1. 既存情報確認・要件定義** 👤➡️🤖
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

#### **A-2. 統合設計** 🤖➡️👤
```yaml
参加者: リーダーエージェント → ユーザーレビュー
トリガー: ユーザーの統合設計指示

workflow:
  1. 既存技術スタック・アーキテクチャとの整合性確認
  2. 既存システムに適合した設計提案
  3. 既存データベースとの統合設計
  4. 既存APIとの整合性を保った仕様設計
  5. 既存システムへの影響を考慮したユーザーレビュー・承認

execution_details:
  existing_system_integration:
    - 既存アーキテクチャパターンとの整合性確保
    - 既存データベーススキーマとの統合設計
    - 既存API仕様との互換性確保
    - 既存コーディング規約・設計パターンの踏襲
  
  completion_action:
    - 既存プロジェクトとの整合性を確保した設計書を提出

deliverables:
  - 統合設計書
  - API仕様書 (OpenAPI) - 既存APIとの統合仕様含む
  - データベーススキーマ（既存スキーマとの統合設計含む）
  - 既存システム統合設計書
```

#### **A-3以降**
```yaml
workflow_continuation:
  - A-3以降は新規プロジェクトのPhase 2以降と同様のフローを実行
  - 既存システムとの整合性を保ちながら、タスク分割→実装→テスト→統合を実行
```

---

### **📦 ai-framework未導入プロジェクトの移行 + 機能追加ワークフロー**

#### **M-0. 既存プロジェクト移行** 🤖
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

#### **M-1以降**
```yaml
workflow_continuation:
  - M-1以降は「ai-framework導入済みプロジェクトの機能追加・改修ワークフロー」のA-1以降と同様
  - 移行済みの .ai/knowledge_base/ 情報を活用して機能追加・改修を実行
```

---

## 📚 関連ドキュメント

- **[08_practical_agent_communication_system.md](./08_practical_agent_communication_system.md)**: エージェント間通信システムの詳細仕様