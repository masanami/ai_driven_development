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
  role: "テスト設計・E2Eテスト・品質保証"
```

### **開発環境構成**
```bash
# メインリポジトリ
main-repo/
├── main branch (統合ブランチ)
├── feature branches (機能ブランチ - 動的作成)
└── worktrees/ (並列作業環境 - 動的作成)
    ├── ../feature-auth/                  # engineer-1が作成・担当
    ├── ../feature-data-management/       # engineer-2が作成・担当
    ├── ../feature-api-integration/       # engineer-1が追加作成・担当
    └── ../feature-ui-components/         # engineer-2が追加作成・担当

# 動的タスク分配の例
dynamic_task_assignment:
  startup_phase:
    - "engineer-1": 待機状態（タスク分配待ち）
    - "engineer-2": 待機状態（タスク分配待ち）
    - "qa-agent": 待機状態（テスト設計準備）
  
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
  - 要件定義書 (.ai/knowledge_base/01_requirements_analysis/)
  - 機能要求一覧 (GitHub Issues)
  - 受け入れ基準 (GitHub Issues)
```

##### **1-2. 基本設計** 🤖➡️👤
```yaml
参加者: リーダーエージェント → ユーザーレビュー
トリガー: ユーザーの基本設計指示

workflow:
  1. 要件定義に基づく技術スタック選定
  2. システムアーキテクチャ設計
  3. データベース設計
  4. API仕様設計
  5. ユーザーレビュー・承認

deliverables:
  - システム設計書
  - API仕様書 (OpenAPI)
  - データベーススキーマ
  - 技術選定理由書
```

#### **Phase 2: タスク分割・テスト設計・環境準備**

##### **2-1. タスク分割** 🤖
```yaml
参加者: リーダーエージェント
トリガー: ユーザーのタスク分割指示

workflow:
  1. 機能要求を親タスクに分割
  2. 親タスクを適度な粒度の子タスクに分解
  3. タスク間の依存関係を分析
  4. 並列実行可能なタスクを特定
  5. タスク優先度付け

execution_details:
  task_breakdown_process:
    - 機能要求を並列実行可能なタスクに分割
    - タスク間の依存関係を分析・整理
    - タスク優先度付け
    - 実装スケジュール作成
  
  completion_action:
    - テスト設計とのタスク分割結果を共有

deliverables:
  - タスク分割表 (GitHub Issues)
  - 依存関係図
  - 実装スケジュール
```

##### **2-2. テスト設計・TDD準備** 🤖 ⚡ 並列実行
```yaml
参加者: QAエージェント (Claude Code)
トリガー: 基本設計完了・ユーザーのテスト設計指示

setup_requirement:
  - QAエージェント（Claude Code）起動・指示
  - @ai-framework/qa_agent_setup_template.md の基本セットアップ指示を使用

tdd_preparation:
  test_strategy:
    - テスト駆動開発戦略の策定
    - 単体テスト設計方針
    - 統合テスト戦略
    - E2Eテストシナリオ概要
  
  test_case_design:
    - 機能別テストケース設計
    - API仕様に基づくテストケース
    - 異常系・境界値テストケース
    - パフォーマンステストケース
  
  test_environment_spec:
    - テストデータ設計
    - モック・スタブ仕様
    - テスト環境要件
    - CI/CDテストパイプライン設計

execution_details:
  implementation_tasks:
    - テスト駆動開発戦略の策定
    - 機能別テストケース設計
    - テストデータ設計・モック・スタブ仕様
    - CI/CDテストパイプライン設計
  
  completion_action:
    - TDD実装ガイドライン・テストケース仕様書を配布

deliverables:
  - TDD実装ガイドライン
  - 機能別テストケース仕様書
  - テストデータセット
  - テスト環境構築仕様書
  - 自動テストスクリプト雛形
```

##### **2-3. エージェント起動・待機** 🤖
```yaml
参加者: リーダーエージェント
トリガー: ユーザーのエージェント起動指示（タスク分割完了後）

agent_startup:
  tmux_environment_setup:
    - tmux直接通信環境の構築
    - 固定エージェント構成での起動
    - 各エージェントの役割設定・待機状態
  
  agent_initialization:
    - LEADER: プロジェクト全体管理・タスク分配準備
    - engineer-1: 汎用エンジニア・タスク分配待ち
    - engineer-2: 汎用エンジニア・タスク分配待ち
    - qa-agent: テスト設計・品質保証準備
  
  readiness_confirmation:
    - 各エージェントの起動確認
    - 通信システムの動作確認
    - タスク分配開始準備完了

execution_details:
  implementation_tasks:
    - ./setup-agent-communication.sh でtmux環境構築
    - ./start-agents.sh で全エージェント起動
    - 各エージェントの指示書読み込み・役割設定
    - LEADERによるタスク分配準備
  
  completion_action:
    - エージェント起動完了・タスク分配開始可能状態を報告
```

#### **Phase 3: 動的タスク分配・TDD並列実装**

##### **3-1. 動的タスク分配・環境構築** 🤖➡️🤖🤖
```yaml
参加者: LEADERエージェント → エンジニアエージェント
トリガー: エージェント起動完了・タスク分配開始指示

dynamic_task_assignment:
  task_distribution_process:
    - LEADERが分割されたタスクを各エンジニアエージェントに分配
    - 各エンジニアエージェントが担当機能を確認・受諾
    - 必要に応じてタスクの詳細確認・調整
  
  worktree_environment_creation:
    - 各エンジニアエージェントが担当機能用のgit worktree環境を作成
    - 機能別ブランチの作成・チェックアウト
    - 作業ディレクトリでの開発環境セットアップ
  
  environment_isolation_setup:
    - 環境変数・設定ファイルの個別管理
    - データベース接続・ポート番号の分離設定
    - テスト実行環境の個別構築

execution_examples:
  leader_task_assignment:
    - "engineer-1への指示: 機能A（例：認証機能）を担当してください"
    - "engineer-2への指示: 機能B（例：データ管理機能）を担当してください"
  
  engineer_environment_setup:
    - engineer-1: "git worktree add ../feature-auth feature/auth"
    - engineer-2: "git worktree add ../feature-data-management feature/data-management"
    - 各エージェント: 作業ディレクトリでの環境セットアップ実行

completion_action:
  - 各エンジニアエージェントの環境構築完了確認
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
    - 担当機能: 機能A（例：認証機能）
    - 作業環境: ../feature-auth/ worktree
    - 実装内容:
      * 認証APIテスト実装
      * バリデーション・セキュリティロジック実装
      * 権限チェック・セッション管理テスト実装
      * 実装中の認証フロー詳細設計調整
    - 成果物: PR作成（テスト含む）
  
  engineer-2_assigned_tasks:
    - 担当機能: 機能B（例：データ管理機能）
    - 作業環境: ../feature-data-management/ worktree
    - 実装内容:
      * データCRUD操作テスト実装
      * データベース連携・バリデーションテスト
      * データ整合性・パフォーマンステスト実装
      * 実装中のデータモデル詳細設計調整
    - 成果物: PR作成（テスト含む）
  
  additional_task_assignment:
    - 必要に応じてengineer-1, engineer-2に追加タスクを分配
    - 例: engineer-1にAPI統合機能を追加分配
    - 各エージェントが複数worktree環境で並行作業可能

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
  - テストカバレッジ > 90%
  - 全テストケース成功
  - コード品質チェック（ESLint/Prettier）
  - TypeScript型安全性確保
  - 実装中の設計調整の適切な文書化
```

##### **3-3. TDD進捗監視・通知** 🤖➡️👤
```yaml
監視システム:
  tdd_progress_tracking:
    - Red-Green-Refactorサイクルの監視
    - テストケース実装進捗の追跡
    - テストカバレッジのリアルタイム監視
    - 実装品質メトリクスの計測
  
  notification_chain:
    engineer_agents: 
      - TDDサイクル完了 → リーダーエージェントに通知
      - テスト失敗継続 → エスカレーション通知
      - 設計課題発見 → 関連エージェントに共有
    
    leader_agent:
      - TDD進捗サマリー → ユーザーに定期報告
      - 品質目標達成 → ユーザーに成果通知
      - 設計変更必要 → ユーザーに即座相談

github_integration:
  - テスト結果の自動更新
  - コードカバレッジレポート生成
  - 品質メトリクス可視化
```

#### **Phase 4: レビュー・統合**

##### **4-1. PRレビュー** 👤🤖
```yaml
参加者: ユーザー・リーダーエージェント
トリガー: エンジニアエージェントのPR作成完了通知

execution_details:
  automated_checks:
    - 全テストケース実行・成功確認
    - テストカバレッジ基準達成確認（> 90%）
    - コード品質チェック（ESLint/Prettier）
    - セキュリティスキャン
    - パフォーマンステスト
  
  leader_agent_review:
    - TDD原則遵守確認
    - テストケース品質評価
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
    - テストカバレッジ基準達成
    - 全自動テスト成功
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
    - マージ前の統合テスト実行
    - テスト競合の自動解決
    - テストデータ統合・調整
  
  conflict_resolution_strategy:
    - テストケース競合の優先度判定
    - 実装競合の自動調整
    - 複雑な競合はエージェント間協議で解決
  
  post_merge_actions:
    - 統合テストスイート実行
    - 回帰テスト実行
    - パフォーマンステスト実行
    - デプロイメント準備
  
  completion_action:
    - 統合結果を報告
```

#### **Phase 5: 統合テスト・最終品質保証**

##### **5-1. 統合テスト・E2Eテスト** 🤖
```yaml
参加者: QAエージェント
トリガー: ユーザーの統合テスト開始指示

execution_details:
  system_integration_tests:
    - サービス間連携テスト
    - API統合テスト実行
    - データフロー統合テスト
    - セキュリティ統合テスト
  
  e2e_tests:
    - ユーザーシナリオテスト実行
    - ブラウザ自動化テスト
    - モバイル対応テスト
    - アクセシビリティテスト
  
  performance_tests:
    - 負荷テスト実行
    - ストレステスト実行
    - メモリリークテスト
    - レスポンス時間測定
  
  test_execution_strategy:
    - 段階的テスト実行
    - 失敗時の自動分析・報告
    - パフォーマンス基準達成確認
  
  completion_action:
    - 統合テスト結果を報告
```

##### **5-2. 最終品質確認・本番準備** 🤖
```yaml
参加者: QAエージェント・リーダーエージェント
トリガー: 統合テスト完了

execution_details:
  comprehensive_quality_checks:
    - 全機能の統合確認
    - 非機能要件の達成確認
    - セキュリティ要件の達成確認
    - パフォーマンス要件の達成確認
  
  production_readiness_checks:
    - 本番環境互換性確認
    - デプロイメント手順検証
    - ロールバック手順確認
    - 監視・アラート設定確認
  
  deliverable_creation:
    - 統合テスト結果レポート
    - パフォーマンステスト結果
    - セキュリティ検査結果
    - 本番リリース準備完了報告
  
  completion_action:
    - 本番リリース準備完了報告を提出
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
    - .ai/knowledge_base/01_requirements_analysis/ の既存要件確認
    - .ai/knowledge_base/02_technical_architecture/ の既存設計確認
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
  - 更新された要件定義書 (.ai/knowledge_base/01_requirements_analysis/)
  - 機能追加・改修要求一覧 (GitHub Issues)
  - 既存機能への影響評価書
  - 受け入れ基準 (GitHub Issues)
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
  - 既存プロジェクト分析レポート (.ai/knowledge_base/00_existing_project_analysis/)
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

## 🔧 技術要件・アーキテクチャ

### **エージェント間通信要件**

#### **tmux直接通信システム**
```yaml
communication_architecture:
  approach: "tmux + Claude Code リアルタイム直接通信"
  format: "自然言語会話形式"
  trigger: "即座の送受信・対話型処理"
  location: "tmuxマルチペイン環境"

agent_deployment:
  principle: "tmux統合環境でのリアルタイム協調"
  architecture:
    - session: "agents" （メインセッション）
    - window: 0 （マルチペイン構成）
    - pane.0: LEADER (40% height)
    - pane.1: engineer-1 (30% height)
    - pane.2: engineer-2 (15% height) 
    - pane.3: qa-agent (15% height)

communication_protocol:
  direct_messaging: "tmux send-keys による直接送信"
  format_examples:
    - "engineer-1への指示: [具体的なタスク内容]"
    - "engineer-2への連絡: [API仕様変更について]"
    - "qa-agentへの連絡: [実装完了、テストお願いします]"
    - "LEADERへの報告: [タスク完了報告]"

setup_commands: |
  環境構築: ./setup-agent-communication.sh
  エージェント起動: ./start-agents.sh
  通信テスト: ./agent-send.sh
```

#### **自然言語通信フォーマット**
```yaml
# 直接通信メッセージ例
communication_patterns:
  task_assignment:
    format: "[受信者]への指示: [具体的なタスク内容と要件]"
    example: "engineer-1への指示: ユーザー登録APIの実装をお願いします。バリデーション機能とセキュリティチェックも含めてください。"
  
  information_sharing:
    format: "[受信者]への連絡: [共有したい情報・変更内容]"
    example: "engineer-2への連絡: ユーザーモデルにaddressフィールドを追加しました。APIレスポンスの更新をお願いします。"
  
  collaboration_request:
    format: "[受信者]への相談: [相談内容・協力要請]"
    example: "qa-agentへの相談: テストケースの設計について相談があります。エッジケースの検討をお願いします。"
  
  status_report:
    format: "[受信者]への報告: [完了内容・進捗状況・課題]"
    example: "LEADERへの報告: ユーザー登録機能の実装が完了しました。テストカバレッジは95%達成です。"
  
  error_notification:
    format: "[受信者]への緊急連絡: [エラー内容・影響範囲・対応状況]"
    example: "LEADERへの緊急連絡: 決済APIでタイムアウトエラーが発生しています。代替処理を検討中です。"

priority_indicators:
  urgent: "【緊急】" - 即座対応が必要
  high: "【重要】" - 当日中対応が必要  
  normal: 通常の連絡・報告
  low: "【参考】" - 参考情報の共有
```

#### **実際のコミュニケーション例**
```bash
# LEADERからengineer-1への動的タスク分配
$ echo "engineer-1への指示: 機能A（認証機能）を担当してください。
以下の手順で進めてください：
1. git worktree add ../feature-auth feature/auth
2. 作業ディレクトリで開発環境セットアップ
3. TDD方式で認証APIを実装
4. セキュリティ・権限管理機能も含めて実装
影響する他のコンポーネントがあれば、engineer-2に連絡してください。" | tmux send-keys -t agents:0.1 Enter

# engineer-1の環境構築完了報告
$ echo "LEADERへの報告: 認証機能の環境構築が完了しました。
- git worktree環境作成済み: ../feature-auth/
- 開発環境セットアップ完了
- TDD実装を開始します。" | tmux send-keys -t agents:0.0 Enter

# engineer-1からengineer-2への連携相談
$ echo "engineer-2への連絡: 認証APIの実装中です。
データ管理機能で認証情報を使用する予定があれば、
API仕様について相談させてください。
現在検討中の認証モデル:
{
  userId: string,
  sessionToken: string,
  permissions: string[],
  expiresAt: Date
}" | tmux send-keys -t agents:0.2 Enter

# engineer-2からの確認・提案
$ echo "engineer-1への返信: 認証情報の件、確認しました。
データ管理機能では以下の情報が必要です：
- ユーザーID（必須）
- 権限レベル（データアクセス制御用）
- セッション有効性の確認
権限レベルの詳細仕様を教えてください。" | tmux send-keys -t agents:0.1 Enter

# LEADERへの進捗報告
$ echo "LEADERへの報告: 認証機能の実装が完了しました。
- TDD実装完了（テストカバレッジ95%）
- engineer-2との連携でAPI仕様調整済み
- PR作成準備完了
次にqa-agentでのテストレビューをお願いします。" | tmux send-keys -t agents:0.0 Enter
```

#### **リアルタイム協調フロー**
```yaml
communication_workflow:
  startup_sequence:
    1: "./setup-agent-communication.sh でtmux環境構築"
    2: "./start-agents.sh で全エージェント起動"
    3: "各エージェントが指示書読み込み、役割設定"
    4: "全エージェントが待機状態で準備完了"
  
  dynamic_task_assignment_flow:
    task_distribution:
      - "LEADER → engineer-1: 具体的機能タスクの分配"
      - "LEADER → engineer-2: 具体的機能タスクの分配"
      - "各エンジニア: git worktree環境作成・セットアップ"
      - "各エンジニア: 環境構築完了報告"
    
    parallel_implementation:
      - "engineer-1 ⇄ engineer-2: 技術相談・API仕様調整"
      - "engineers → qa-agent: テスト依頼・品質確認"
      - "engineers → LEADER: 進捗報告・課題エスカレーション"
      - "LEADER: 必要に応じて追加タスク分配"
  
  operational_benefits:
    - "エージェント起動の一回性（効率化）"
    - "動的タスク分配による柔軟性"
    - "git worktree環境の動的作成"
    - "リアルタイム協調による迅速開発"

escalation_mechanism:
  immediate_escalation:
    - エラー・問題発生時の即座報告
    - ブロッカー発生時の即座相談
    - 設計変更必要時の即座判断要請
  
  escalation_format:
    - "【緊急】LEADERへの報告: [問題内容と対応状況]"
    - "【相談】ユーザー判断が必要: [判断要求内容]"
```

#### **tmux統合システム設計**
```yaml
system_architecture:
  tmux_integration:
    - session管理による統合環境
    - マルチペイン表示による視覚的監視
    - 直接通信による即座の情報共有
    - Claude Code統合による自然言語処理
  
  monitoring_capabilities:
    - リアルタイム進捗可視化
    - エージェント状態の即座確認
    - 通信履歴の即座参照
    - 問題発生時の即座対応

practical_benefits:
  development_efficiency:
    - 待機時間の完全削除
    - 情報共有の即座性
    - 問題解決の迅速化
    - チーム協調の自然化
  
  user_experience:
    - 視覚的な進捗確認
    - 直感的な状況把握
    - 簡単な操作・管理
    - 問題の早期発見
```

### **環境分離・依存関係管理**

#### **開発環境分離戦略**
```yaml
environment_isolation:
  workspace_management:
    - git worktreeによる物理的分離
    - 環境変数・設定ファイルの個別管理
    - データベース・外部サービス接続の分離
  
  dependency_management:
    - パッケージ依存関係の競合回避
    - 共有ライブラリ・コンポーネントの調整
    - API仕様変更の影響範囲制御

conflict_prevention:
  - ファイル変更の事前調整機能
  - 共通リソースアクセスの排他制御
  - マージコンフリクト予防システム
```

#### **依存関係監視システム**
```yaml
dependency_tracking:
  change_detection:
    - ファイル変更のリアルタイム追跡
    - 影響範囲の自動分析
    - 競合可能性の事前警告
  
  coordination_mechanisms:
    - エージェント間の変更調整
    - 共通コンポーネント更新の協議
    - API仕様変更の事前通知
```

### **パフォーマンス最適化戦略**

#### **並列実行最適化**
```yaml
scheduling_optimization:
  task_distribution:
    - 依存関係分析による最適配布
    - エージェント能力評価・マッチング
    - 負荷分散アルゴリズムの適用
  
  efficiency_maximization:
    - 並列実行可能タスクの最大化
    - 待機時間の最小化
    - リソース利用率の向上

adaptive_scheduling:
  - 動的なタスク再配布
  - 完了予測時間に基づく調整
  - ボトルネック解消のための最適化
```

#### **リソース使用効率化**
```yaml
resource_optimization:
  token_management:
    - プロンプト最適化による消費削減
    - コンテキスト再利用戦略
    - バッチ処理による効率化
  
  memory_management:
    - 不要なコンテキストの削除
    - 共通知識ベースの活用
    - メモリリーク防止対策
  
  network_optimization:
    - API呼び出し回数の最小化
    - レスポンスキャッシュ戦略
    - 並列リクエストの制御
```

---

## 🚨 エラーハンドリング・フォールバック戦略

### **障害対応シナリオ**

#### **エージェント障害対応**
```yaml
failure_scenarios:
  agent_timeout:
    detection: "30分間無応答"
    response_strategy: 
      - 他エージェントへのタスク再配布
      - 進捗状況の保存・継承
      - ユーザーへの状況報告
  
  implementation_error:
    detection: "テスト失敗・ビルドエラー"
    response_strategy:
      - エラー内容の自動分析
      - 修正方針の提案・実行
      - 必要に応じたタスク分割
  
  environment_issue:
    detection: "環境構築失敗"
    response_strategy:
      - 環境の自動再構築
      - 依存関係の再確認・修正
      - 代替環境の提供
```

#### **自動回復メカニズム**
```yaml
recovery_strategies:
  automatic_retry:
    - 段階的バックオフによるリトライ
    - エラータイプ別の回復戦略
    - 最大リトライ回数の制限
  
  fallback_mechanisms:
    - 代替手法による継続実行
    - 縮退運転による最小限機能確保
    - 手動介入への適切なエスカレーション

learning_from_failures:
  - 失敗パターンの学習・蓄積
  - 予防策の自動適用
  - システム全体の耐障害性向上
```

---

## 📚 関連ドキュメント

- **[07_implementation_strategy_and_optimization.md](./07_implementation_strategy_and_optimization.md)**: 段階的導入戦略・コスト管理・KPI・将来拡張の詳細ガイド

---

*このマルチエージェント実運用ワークフロー仕様書は、実際の運用結果と学習内容に基づいて継続的に改善・進化させていきます。*