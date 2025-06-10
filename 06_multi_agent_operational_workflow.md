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
  role: "統合指揮・要件整理・基本設計・進捗管理"
  
engineer_agents:
  tool: "Claude Code (multiple instances)"
  role: "詳細設計・実装・単体テスト・PR作成"
  naming_convention: "agent-{feature-task-name}"
  examples:
    - "agent-user-registration"     # ユーザー登録機能
    - "agent-shopping-cart"         # ショッピングカート機能
    - "agent-payment-integration"   # 決済統合機能
    - "agent-admin-dashboard"       # 管理画面機能
  
qa_agent:
  tool: "Claude Code"
  role: "テスト設計・E2Eテスト・品質保証"
```

### **開発環境構成**
```bash
# メインリポジトリ
main-repo/
├── main branch (統合ブランチ)
├── feature branches (機能ブランチ)
└── worktrees/ (並列作業環境)
    ├── ../feature-user-registration/     # agent-user-registration 作業ディレクトリ
    ├── ../feature-shopping-cart/         # agent-shopping-cart 作業ディレクトリ
    ├── ../feature-payment-integration/   # agent-payment-integration 作業ディレクトリ
    └── ../feature-admin-dashboard/       # agent-admin-dashboard 作業ディレクトリ

# エージェントとタスクの対応例
task_agent_mapping:
  "feature/user-registration" → "agent-user-registration"
  "feature/shopping-cart" → "agent-shopping-cart"  
  "feature/payment-integration" → "agent-payment-integration"
  "feature/admin-dashboard" → "agent-admin-dashboard"
```

---

## 🔄 運用ワークフロー

### **Phase 1: 要件定義・基本設計**

#### **1-1. 要求整理・要件定義** 👤➡️🤖
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
  - 要件定義書 (GitHub Wiki)
  - 機能要求一覧 (GitHub Issues)
  - 受け入れ基準 (GitHub Issues)
```

#### **1-2. 基本設計** 🤖➡️👤
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

### **Phase 2: タスク分割・テスト設計・環境準備**

#### **2-1. タスク分割** 🤖
```yaml
参加者: リーダーエージェント
トリガー: ユーザーのタスク分割指示

workflow:
  1. 機能要求を親タスクに分割
  2. 親タスクを適度な粒度の子タスクに分解
  3. タスク間の依存関係を分析
  4. 並列実行可能なタスクを特定
  5. タスク優先度付け

deliverables:
  - タスク分割表 (GitHub Issues)
  - 依存関係図
  - 実装スケジュール
```

#### **2-2. テスト設計・TDD準備** 🤖 ⚡ 並列実行
```yaml
参加者: QAエージェント (Claude Code)
トリガー: 基本設計完了・ユーザーのテスト設計指示

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

deliverables:
  - TDD実装ガイドライン
  - 機能別テストケース仕様書
  - テストデータセット
  - テスト環境構築仕様書
  - 自動テストスクリプト雛形
```

#### **2-3. 並列環境構築** 🤖
```yaml
参加者: リーダーエージェント
トリガー: ユーザーの環境構築指示

environment_setup:
  git_worktree_creation:
    - 機能別ブランチの作成
    - 各エージェント専用作業ディレクトリの準備
    - 分離された開発環境の構築
  
  agent_assignment:
    - Claude Code インスタンスの起動
    - 各エージェントへのタスク配布
    - 作業環境の個別設定
  
  tdd_environment_setup:
    - テスト実行環境の準備
    - 各エージェント用テストデータベース構築
    - CI/CDパイプラインの個別設定

environment_isolation:
  - 環境変数の分離管理
  - データベース接続情報の個別設定
  - ポート番号の重複回避設定
  - テスト実行ポートの分離
```

### **Phase 3: TDD並列実装**

#### **3-1. エンジニアエージェントTDD並列実行** 🤖⚡🤖⚡🤖
```yaml
参加者: エンジニアエージェント (複数Claude Code)
トリガー: リーダーエージェントのタスク配布・テスト仕様完了

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
  agent-user-registration_tasks:
    - ユーザー登録機能のTDD実装
      * ユーザー登録APIテスト実装
      * バリデーション・認証ロジック実装
      * セキュリティ・重複チェックテスト実装
      * 実装中のユーザー登録フロー詳細設計調整
    - PR作成（テスト含む）
  
  agent-shopping-cart_tasks:
    - ショッピングカート機能のTDD実装
      * カート操作コンポーネントテスト実装
      * 商品追加・削除・更新インタラクションテスト
      * カート状態管理テスト実装
      * 実装中のカートUI・UX調整
    - PR作成（テスト含む）
  
  agent-payment-integration_tasks:
    - 決済統合機能のTDD実装
      * 決済APIエンドポイントテスト実装
      * 決済フロー・エラーハンドリングテスト
      * 外部決済サービス連携テスト実装
      * 実装中の決済セキュリティ・データモデル調整
    - PR作成（テスト含む）

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

#### **3-2. TDD進捗監視・通知** 🤖➡️👤
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

### **Phase 4: レビュー・統合**

#### **4-1. PRレビュー** 👤🤖
```yaml
参加者: ユーザー・リーダーエージェント
トリガー: エンジニアエージェントのPR作成完了通知

tdd_review_workflow:
  automated_checks:
    - 全テストケース実行・成功確認
    - テストカバレッジ基準達成確認
    - コード品質チェック
    - セキュリティスキャン
    - パフォーマンステスト
  
  leader_agent_review:
    - TDD原則遵守確認
    - テストケース品質評価
    - 実装とテストの整合性確認
    - リファクタリング品質評価
  
  user_review:
    - ビジネスロジックの正確性確認
    - 受け入れ基準の達成確認
    - UX/UI の確認

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

#### **4-2. マージ・コンフリクト解消** 🤖
```yaml
参加者: リーダーエージェント
トリガー: ユーザーのレビュー完了

merge_strategy:
  test_driven_merge:
    - マージ前の統合テスト実行
    - テスト競合の自動解決
    - テストデータ統合・調整
  
  conflict_resolution:
    - テストケース競合の優先度判定
    - 実装競合の自動調整
    - 複雑な競合はエージェント間協議

post_merge_actions:
  - 統合テストスイート実行
  - 回帰テスト実行
  - パフォーマンステスト実行
  - デプロイメント準備
```

### **Phase 5: 統合テスト・最終品質保証**

#### **5-1. 統合テスト・E2Eテスト** 🤖
```yaml
参加者: QAエージェント
トリガー: ユーザーの統合テスト開始指示

integration_testing:
  system_integration:
    - サービス間連携テスト
    - API統合テスト実行
    - データフロー統合テスト
    - セキュリティ統合テスト
  
  e2e_testing:
    - ユーザーシナリオテスト実行
    - ブラウザ自動化テスト
    - モバイル対応テスト
    - アクセシビリティテスト
  
  performance_testing:
    - 負荷テスト実行
    - ストレステスト実行
    - メモリリークテスト
    - レスポンス時間測定

test_execution_strategy:
  - 段階的テスト実行
  - 失敗時の自動分析・報告
  - パフォーマンス基準達成確認
```

#### **5-2. 最終品質確認・本番準備** 🤖
```yaml
参加者: QAエージェント・リーダーエージェント
トリガー: 統合テスト完了

final_quality_assurance:
  comprehensive_testing:
    - 全機能の統合確認
    - 非機能要件の達成確認
    - セキュリティ要件の達成確認
    - パフォーマンス要件の達成確認
  
  production_readiness:
    - 本番環境互換性確認
    - デプロイメント手順検証
    - ロールバック手順確認
    - 監視・アラート設定確認

deliverables:
  - 統合テスト結果レポート
  - パフォーマンステスト結果
  - セキュリティ検査結果
  - 本番リリース準備完了報告
```

---

## 🔧 技術要件・アーキテクチャ

### **エージェント間通信要件**

#### **ファイルベース通信システム**
```yaml
communication_architecture:
  approach: "ファイルベース非同期通信"
  format: "YAML（プロジェクト統一形式）"
  trigger: "ユーザー指示による確認・処理"
  location: "各エージェントのgit worktree環境"

agent_task_mapping:
  principle: "git featureブランチ名とエージェント名の統一"
  examples:
    - git_branch: "feature/user-registration" → agent_name: "agent-user-registration"
    - git_branch: "feature/shopping-cart" → agent_name: "agent-shopping-cart"
    - git_branch: "feature/payment-integration" → agent_name: "agent-payment-integration"
    - git_branch: "feature/admin-dashboard" → agent_name: "agent-admin-dashboard"

directory_structure:
  base_path: "agent_communication/"
  subdirectories:
    inbox: "受信ファイル（未処理）"
    outbox: "送信ファイル（送信済み）"
    processed: "処理済みファイル（アーカイブ）"
    templates: "通信テンプレート・規約"

file_naming_convention: "{type}_{from}_{sequential}.yaml"
examples:
  - "interface_change_user-registration_001.yaml"
  - "status_update_shopping-cart_002.yaml"
  - "dependency_request_payment-integration_001.yaml"

file_timestamp_check: |
  作成日時確認: ls -la agent_communication/inbox/
  詳細確認: stat filename.yaml
```

#### **YAML通信フォーマット**
```yaml
# 基本通信フォーマット
communication_template:
  # 必須フィールド
  communication_id: "unique_identifier"
  from: "sender_agent_id"
  to: ["recipient_agent_id1", "recipient_agent_id2"]
  type: "communication_type"
  priority: "low|medium|high|urgent"
  status: "pending|acknowledged|completed|cancelled"
  
  # コンテンツ
  content:
    title: "通信件名"
    # type別の詳細内容
  
  # オプショナル
  deadline: "YYYY-MM-DD形式"
  action_required: true|false
  response_required: true|false

# 通信タイプ定義
communication_types:
  interface_change:
    description: "API・インターフェース変更通知"
    fields:
      - changes: "変更内容リスト"
      - affected_components: "影響範囲"
      - migration_guide: "対応方法"
  
  dependency_request:
    description: "依存関係・協力要請"
    fields:
      - required_items: "必要な成果物・情報"
      - blocking_tasks: "ブロックされているタスク"
      - alternative_approach: "代替案"
  
  status_update:
    description: "作業状況・進捗報告"
    fields:
      - completed_tasks: "完了タスク"
      - current_tasks: "実行中タスク"
      - issues: "課題・問題"
      - eta: "完了予定日"
  
  design_consultation:
    description: "設計相談・レビュー依頼"
    fields:
      - design_area: "設計対象領域"
      - proposed_solution: "提案内容"
      - concerns: "懸念点・検討事項"
  
  error_report:
    description: "エラー・問題報告"
    fields:
      - error_details: "エラー詳細"
      - reproduction_steps: "再現手順"
      - impact_assessment: "影響度評価"
      - suggested_solution: "対応案"
```

#### **実際のコミュニケーション例**
```yaml
# interface_change_user-registration_001.yaml
communication_id: "user_reg_001"
from: "agent-user-registration"
to: 
  - "agent-shopping-cart"
  - "agent-admin-dashboard"
type: "interface_change"
priority: "high"
status: "pending"

content:
  title: "ユーザー登録API仕様変更"
  changes:
    - "ユーザープロフィールにaddress情報追加"
    - "emailバリデーション強化"
    - "ユーザー権限フィールド追加"
  
  affected_components:
    - component: "ショッピングカートのユーザー情報表示"
      action: "住所情報表示機能の追加"
      files: ["src/components/Cart/UserInfo.jsx"]
    - component: "管理画面のユーザー管理"
      action: "新しいユーザーフィールド対応"
      files: ["src/admin/UserManagement.jsx"]
  
  migration_guide: |
    1. User APIレスポンスから address フィールドを取得
    2. 権限ベースの機能制御を実装
    3. 既存ユーザーデータのマイグレーション対応

deadline: "2024-12-31"
action_required: true
response_required: true

notes: |
  ECサイトの住所管理機能強化により、
  ユーザー登録時に詳細住所を収集する必要が生じました。
```

#### **ユーザートリガー型確認フロー**
```yaml
communication_workflow:
  user_instructions:
    periodic_check: "各エージェント、受信ファイルを確認・処理してください"
    milestone_check: "Phase完了時の連絡事項を整理してください"
    issue_resolution: "ブロッカー・課題の解決状況を共有してください"
    design_sync: "設計変更・調整事項を確認してください"
  
  agent_response_flow:
    1: "inbox/内の未処理ファイルをスキャン"
    2: "各ファイルを内容に応じて処理"
    3: "必要に応じて返信ファイル作成"
    4: "処理済みファイルをprocessed/に移動"
    5: "自分の状況をstatus updateで送信"
  
  timing_recommendations:
    - "各Phase開始時"
    - "重要マイルストーン達成時" 
    - "問題・ブロッカー発生時"
    - "日次定期確認（1-2回）"
    - "緊急事態発生時"

escalation_rules:
  auto_escalate_conditions:
    - "priority: urgent"
    - "deadline過ぎたpending status"
    - "error_report type"
  
  escalation_targets:
    - "leader_agent（リーダーエージェント）"
    - "user（ユーザー直接）"
```

#### **通知システム設計**
```yaml
notification_requirements:
  real_time_communication:
    - エージェント間のリアルタイム状況共有
    - タスク完了・エラー発生の即座通知
    - 依存関係ブロックの自動検出・通知
  
  escalation_mechanism:
    - 自動エスカレーション条件の設定
    - ユーザー介入が必要な状況の判定
    - 重要度に応じた通知方法の選択

integration_points:
  - GitHub Issues/PR自動更新
  - Project Board進捗同期
  - Slack/Discord通知連携
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

---

## ⚡ パフォーマンス最適化戦略

### **並列実行最適化**

#### **タスクスケジューリング戦略**
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

## 📈 段階的導入戦略

### **Phase 1: 最小構成（1-2週間）**
```yaml
minimal_setup:
  agents:
    - リーダーエージェント (Claude Code)
    - エンジニアエージェント×1 (Claude Code)
  
  features:
    - 基本的な要件定義
    - 単一機能の実装
    - 簡単なPRレビュー
  
  success_criteria:
    - 要件から実装まで一貫フロー
    - エージェント間の基本通信
    - git worktree環境の構築
```

### **Phase 2: 並列化導入（2-3週間）**
```yaml
parallel_setup:
  agents:
    - リーダーエージェント (Claude Code)
    - エンジニアエージェント×2-3 (Claude Code)
  
  features:
    - 並列タスク実行
    - 進捗監視システム
    - 自動化されたマージ
  
  success_criteria:
    - 真の並列開発実現
    - コンフリクト最小化
    - 効率性の向上確認
```

### **Phase 3: 完全自動化（3-4週間）**
```yaml
full_automation:
  agents:
    - リーダーエージェント (Claude Code)
    - エンジニアエージェント×3-5 (Claude Code)
    - QAエージェント (Claude Code)
  
  features:
    - 完全自動化フロー
    - 高度な品質保証
    - インテリジェントなエラーハンドリング
  
  success_criteria:
    - 人間の介入最小化
    - 高品質なアウトプット
    - スケーラブルな体制
```

---

## 💰 コスト管理・ROI最適化

### **コスト要因と対策**
```yaml
cost_factors:
  token_consumption:
    drivers:
      - 複数エージェント同時実行
      - 長いコンテキスト維持
      - 試行錯誤による再実行
    
    optimization_strategies:
      - プロンプト効率化
      - コンテキスト圧縮
      - 成功パターンの学習・再利用

  execution_time:
    drivers:
      - エージェント間の待機時間
      - エラー発生による遅延
      - レビューサイクルの長期化
    
    optimization_strategies:
      - 並列処理の最適化
      - 早期エラー検出
      - 自動化レベルの向上

roi_targets:
  time_savings:
    - 開発時間: 50-70%短縮
    - レビュー時間: 30-50%短縮  
    - テスト時間: 60-80%短縮
  
  quality_improvement:
    - バグ率: 40-60%削減
    - コード品質: 20-30%向上
    - ドキュメント品質: 50-70%向上
```

---

## 📋 成功指標・KPI

### **定量的指標**
```yaml
quantitative_kpis:
  development_efficiency:
    - 機能実装時間: baseline比較
    - コード行数/時間: 生産性測定
    - PR作成〜マージ時間: フロー効率性
  
  quality_metrics:
    - バグ発見率: 本番投入前の品質
    - テストカバレッジ: 自動テスト充実度
    - コード複雑度: 保守性指標
  
  collaboration_effectiveness:
    - エージェント稼働率: リソース活用度
    - タスク完了率: 計画精度
    - ユーザー介入回数: 自動化度合い
```

### **定性的指標**
```yaml
qualitative_assessment:
  user_experience:
    - 開発者満足度
    - 学習曲線の改善
    - ストレス軽減効果
  
  output_quality:
    - コード可読性
    - 設計一貫性
    - ドキュメント完成度
  
  process_maturity:
    - 問題解決能力
    - 適応性・柔軟性
    - 継続改善能力
```

---

## 🔮 将来拡張・進化方向

### **自動化レベルの向上**
```yaml
automation_evolution:
  current_level:
    - ユーザートリガー制御
    - 半自動化されたレビュー
    - 基本的なエラーハンドリング
  
  next_level:
    - インテリジェントな自律判断
    - 予測的問題解決
    - 動的な最適化
  
  future_vision:
    - 完全自律開発チーム
    - 創発的問題解決
    - 人間とAIの真の協業
```

### **学習・改善システム**
```yaml
learning_system:
  pattern_recognition:
    - 成功パターンの抽出
    - 失敗要因の分析
    - ベストプラクティスの蓄積
  
  adaptive_optimization:
    - 動的なプロセス調整
    - パーソナライズされた最適化
    - 予測的リソース配分
  
  knowledge_evolution:
    - 組織知識の蓄積
    - エージェント間の知識共有
    - 継続的なスキル向上
```

---

*このマルチエージェント実運用ワークフロー仕様書は、実際の運用結果と学習内容に基づいて継続的に改善・進化させていきます。* 