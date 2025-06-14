# Phase 3: 並列実装・エージェント間通信ワークフロー

## 🎯 フェーズ概要
**目的**: 複数エージェントがリアルタイムで連携し、TDD並列実装を実行する
**担当**: LEADERエージェント（調整）+ engineer-1,2,3（実装）+ qa-agent（品質保証）
**完了条件**: 全Issue実装完了・逐次PR作成・レビュー・マージ完了

## 📋 GitHub Flow実行
**並列実装・逐次統合**: 
- **実装**: 各エンジニアが feature/issue-{番号}-{機能名} ブランチで並列実装
- **PR作成**: Issue完了次第、即座にPR作成・LEADERに報告
- **逐次レビュー**: LEADERが依存関係を考慮して優先順位付け・レビュー
- **逐次マージ**: 依存関係問題なければ即座にmainブランチマージ
- **統合確認**: マージ後の統合テスト・品質確認

---

## 🚨 エージェント間通信プロトコル【最重要】

**📖 詳細な通信システム**: `08_practical_agent_communication_system.md` を参照【必読】

### **基本通信フォーマット**
- **LEADERからエンジニア**: `**engineer-{番号}への指示:** {内容}`
- **エンジニアからLEADER**: `**LEADERへの報告:** {内容}`  
- **エンジニア間連絡**: `**engineer-{番号}への連絡:** {内容}`

---

## 📋 実行チェックリスト

### **Step 3-1: タスク分配・環境構築** 🤖➡️🤖🤖
```yaml
トリガー: Phase 2完了 + ユーザーの明示的なタスク分配開始指示
実行者: LEADERエージェント → エンジニアエージェント

🆕 LEADER MANDATORY PROTOCOL:
critical_recognition:
  - "私はリーダーエージェントです。実装は行いません"
  - "エンジニアエージェント（engineer-1, engineer-2, engineer-3）に作業を分配します"
  - "各エンジニアエージェントは別のClaude Codeインスタンスです"

🚨 CRITICAL COMMUNICATION STEPS:
step_1_team_notification:
  message: |
    🚨 マルチエージェント体制でのタスク分配を開始します
    
    **エンジニアエージェント各位へ:**
    - engineer-1: 汎用エンジニア・タスク分配待ち
    - engineer-2: 汎用エンジニア・タスク分配待ち  
    - engineer-3: 汎用エンジニア・タスク分配待ち
    - qa-agent: E2Eテスト設計・実装待ち
    
    GitHub Issues が作成済みです。各エージェントにタスクを分配します。

step_2_individual_assignment:
  engineer_1: |
    **engineer-1への指示:**
    
    🚨 重要: まず以下のファイルを読み込んでください:
    1. @workflow_phase_3_parallel_implementation.md
    2. @08_practical_agent_communication_system.md
    
    担当Issue: Issue #{Issue番号}（{機能名}）
    
    ファイル読み込み後、以下の手順で作業を開始してください:
    1. GitHub Issue #{Issue番号} を確認
    2. git worktree add ../issue-{番号}-{機能} feature/issue-{番号}-{機能}
    3. 作業ディレクトリに移動
    4. TDD で実装開始（ワークフローのTDD詳細手順に従って）
    
    ファイル読み込み・作業開始後、進捗を報告してください。
  
  engineer_2: |
    **engineer-2への指示:**
    [同様のフォーマットで個別指示]
  
  engineer_3: |
    **engineer-3への指示:**
    [同様のフォーマットで個別指示]

step_3_confirmation:
  - 各エンジニアエージェントからの「作業開始しました」確認を待つ
  - 確認完了後、並列実装フェーズに移行
  - "全エンジニアエージェントへのタスク分配が完了しました。並列実装を開始してください。"

✅ 完了判定:
  - 全エンジニアエージェントがタスク受諾・確認済み
  - 各エージェントがworktree環境構築完了
  - 作業開始確認済み

🔄 次ステップ:
  - Step 3-2: TDD並列実装実行開始
```

### **Step 3-2: TDD並列実装実行** 🤖⚡🤖⚡
```yaml
トリガー: Step 3-1完了・全エージェント作業開始確認
実行者: エンジニアエージェント（並列）

🆕 エンジニアエージェント個別認識:
engineer_identity:
  engineer_1: "私はengineer-1です。Issue #{担当Issue番号}を担当します"
  engineer_2: "私はengineer-2です。Issue #{担当Issue番号}を担当します"
  engineer_3: "私はengineer-3です。Issue #{担当Issue番号}を担当します"

role_clarity:
  - "私は実装専門のエンジニアエージェントです"
  - "LEADERからの指示に従ってTDD実装を行います"
  - "進捗・課題・完了はLEADERに報告します"

🚨 CRITICAL TDD WORKFLOW:
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

parallel_tdd_execution_examples:
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
  
  engineer-3_assigned_tasks:
    - 担当Issue: Issue #3（API統合機能実装）
    - 作業環境: ../issue-3-api-integration/ worktree
    - 実装内容:
      * GitHub Issue要件に基づくAPI統合テスト実装
      * 外部API連携・エラーハンドリングテスト
      * API仕様準拠・レスポンス処理テスト実装
      * 実装中のAPI統合詳細設計調整
    - 成果物: PR作成（Issue #3リンク・テスト含む）
  
  additional_issue_assignment:
    - 必要に応じてengineer-1, engineer-2, engineer-3に追加Issueを分配
    - 例: engineer-1にIssue #5（UI改善機能）を追加分配
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

🔄 進捗報告プロトコル:
regular_updates:
  format: "**LEADERへの進捗報告:** Issue #{番号} - {進捗状況}"
  frequency: "重要なマイルストーン達成時"
  content: "Red/Green/Refactorフェーズの進捗・課題・完了予定"

completion_notification:
  format: "**LEADERへの完了報告:** Issue #{番号} - 実装完了・PR作成済み"
  required_info: "PR番号・テスト結果・レビュー依頼"

🚨 CRITICAL TDD COMMIT STRATEGY:
red_phase_commit:
  - git add .
  - git commit -m "test: Issue #{Issue番号} - {機能名} テストケース実装（Red Phase）"

green_phase_commit:
  - git add .
  - git commit -m "feat: Issue #{Issue番号} - {機能名} 最小実装完了（Green Phase）"

refactor_phase_commit:
  - git add .
  - git commit -m "refactor: Issue #{Issue番号} - {機能名} コード品質向上・リファクタリング完了"

final_commit_before_pr:
  - git add .
  - git commit -m "feat: Issue #{Issue番号} 実装完了 - {機能名} TDD完了・PR作成準備完了"

✅ 完了判定:
  - 各Issue実装完了次第、即座にPR作成・報告
  - 単体テスト成功
  - PR作成済み（適切なコミット履歴含む）
  - LEADERに完了報告済み

🔄 次ステップ:
  - Step 3-3: 逐次PRレビュー・マージフロー開始
```

### **Step 3-3: 逐次PRレビュー・マージフロー** 🤖⚡🔄
```yaml
トリガー: 各エンジニアエージェントのIssue実装完了・PR作成
実行者: LEADERエージェント（レビュー・マージ判定）+ エンジニアエージェント（PR作成）

🚨 CRITICAL PRINCIPLE: 並列実装・逐次統合
基本原則:
  - 各エンジニアエージェントは担当Issue完了次第、即座にPR作成
  - 全Issue完了を待たずに個別にPR作成・レビュー依頼
  - LEADERが依存関係を考慮して優先順位付け・レビュー実行
  - 依存関係に問題なければ即座にmainブランチにマージ
  - 依存関係がある場合は前提PRのマージ後にレビュー

実装フロー:
  1. 各エンジニアが並列で実装開始
  2. 最初に完了したエンジニアがPR作成・報告
  3. LEADERが依存関係チェック・レビュー実行
  4. 問題なければ即座にマージ
  5. 次に完了したエンジニアがPR作成・報告
  6. LEADERが既存マージ内容との整合性確認
  7. 統合テスト実行後マージ
  8. 全Issue完了まで繰り返し

🔄 依存関係管理の具体例:
case_1_independent_feature:
  # 独立機能（認証機能）- 即座マージ可能
  engineer_report: "**LEADERへの報告:** Issue #1（認証機能）実装完了。PR #1作成済み。他機能との依存関係なし。"
  leader_response: "**engineer-1への連絡:** PR #1レビュー完了。依存関係問題なし。mainブランチにマージしました。"
  # PRマージはGitHubが自動的にマージコミットを作成するため、手動コミット不要

case_2_dependent_feature:
  # 依存機能（データ管理機能）- 認証機能との統合確認必要
  engineer_report: "**LEADERへの報告:** Issue #2（データ管理機能）実装完了。PR #2作成済み。認証機能との統合確認お願いします。"
  leader_response: "**engineer-2への連絡:** PR #2レビュー中。認証機能（PR #1マージ済み）との統合テストを実行してください。"

case_3_integration_feature:
  # 高依存機能（API統合機能）- 複数機能との統合確認必要
  engineer_report: "**LEADERへの報告:** Issue #3（API統合機能）実装完了。PR #3作成済み。認証・データ管理機能との統合確認お願いします。"
  leader_response: "**engineer-3への連絡:** PR #3は認証・データ管理機能のマージ完了後にレビューします。現在統合テスト準備中です。"

🎯 LEADERの依存関係判定ロジック:
判定基準:
  independent_features:
    - 他機能に依存しない独立機能
    - 即座レビュー・マージ可能
    - 例: 認証機能、ログ機能、設定機能
  
  dependent_features:
    - 他機能のAPIやデータに依存する機能
    - 依存先機能のマージ後にレビュー
    - 統合テスト実行後マージ
    - 例: データ管理機能（認証依存）、レポート機能（データ管理依存）
  
  integration_features:
    - 複数機能を統合する機能
    - 全依存機能のマージ後にレビュー
    - 包括的統合テスト実行後マージ
    - 例: API統合機能、フロントエンド統合機能

レビュー優先順位:
  1. 独立機能のPR（即座処理）
  2. 依存機能のPR（依存先マージ後処理）
  3. 統合機能のPR（全依存先マージ後処理）

✅ 完了判定:
  - 全Issue実装完了・PR作成済み
  - 依存関係に応じた適切な順序でマージ完了
  - 統合テスト成功
  - mainブランチに全機能統合済み
  - 🚨 MANDATORY: Phase 3完了時点でコミット実行
    - git add .
    - git commit -m "feat: Phase 3 並列実装完了 - 全Issue実装・PR統合・mainブランチ統合完了"

🔄 次ステップ:
  - LEADERエージェント: "全Issue実装完了・依存関係に応じた逐次マージ完了。mainブランチに全機能統合済み"
  - LEADERエージェント: "🚨 MANDATORY: Phase 3完了。次フェーズへの移行指示のため、@ai-framework/06_multi_agent_operational_workflow.md をリーダーエージェントに読み込ませてください。"
  - Phase 4: 最終レビュー・品質確認・プロジェクト完了
```

---

## 🎯 重要な制約・注意事項

### **🛑 CRITICAL RULE: リーダーエージェントは実装しない**
```yaml
strict_prohibition:
  - "リーダーエージェントは絶対に実装コードを書かない"
  - "実装はエンジニアエージェントの専門領域"
  - "リーダーの役割は指示・調整・進捗管理のみ"

redirect_instruction:
  - 実装要求があった場合: "実装はengineer-{番号}エージェントが担当します"
  - 技術的質問があった場合: "技術的な詳細は担当エンジニアエージェントに確認してください"
```

### **エージェント間通信の必須事項**
- **各指示に対して必ず確認応答を求める**
- **進捗報告は定期的に実行**
- **課題・ブロッカーは即座にLEADERに報告**
- **他エージェントへの技術的質問は直接通信**

### **品質基準**
- **TDD原則の厳格な遵守**
- **全テストケース成功**
- **コード品質チェック通過**
- **PR作成・レビュー準備完了**

---

## 🔗 関連ドキュメント
- **前フェーズ**: workflow_phase_2_task_breakdown.md
- **次フェーズ**: workflow_phase_4_review_integration.md
- **通信システム**: 08_practical_agent_communication_system.md 