# Phase 3: 協業実装・エージェント間通信ワークフロー

## 🎯 フェーズ概要
**目的**: 複数エージェントが1つの機能に集中し、高品質な実装を協業で実現する
**担当**: LEADERエージェント（調整）+ Implementation Engineer（メイン実装）+ Quality Engineer（テスト・品質）+ Documentation Engineer（レビュー支援・ドキュメント）
**実行環境**: **tmux使用開始** - 4分割マルチエージェント体制
**完了条件**: 機能ごとの実装完了・統合PR作成・レビュー・マージ完了

---

## 🚨 エージェント間通信プロトコル【最重要】

**📖 詳細な通信システム**: `@.ai-framework/05_practical_agent_communication_system.md` を参照【必読】

### **基本通信フォーマット**
- **LEADERからエンジニア**: `**engineer-{番号}への指示:** {内容}`
- **エンジニアからLEADER**: `**LEADERへの報告:** {内容}`  
- **エンジニア間連絡**: `**engineer-{番号}への連絡:** {内容}`

---

## 📋 実行チェックリスト

### **Step 3-1: 機能開発チーム編成・環境構築** 🤖➡️🤖🤖
```yaml
トリガー: Phase 2完了 + ユーザーの明示的な開発開始指示
実行者: LEADERエージェント → エンジニアエージェント

LEADER_MANDATORY_PROTOCOL:
  critical_recognition:
    - "私はリーダーエージェントです。実装は行いません"
    - "エンジニアエージェント（Implementation, Quality, Documentation）に役割を分配します"
    - "チーム全体で1つの機能に集中して開発します"

CRITICAL_COMMUNICATION_STEPS:
  step_1_team_notification:
    message: |
      協業体制での機能開発を開始します
      
      **エンジニアエージェント役割分担:**
      - Implementation Engineer: メイン実装担当（TDD統合実装）
      - Quality Engineer: テスト・品質担当（追加テスト・品質保証）
      - Documentation Engineer: レビュー支援・ドキュメント担当
      
      現在のタスク: TASK-{ID}（{機能名}）を協業で実装します。

  step_2_role_based_assignment:
    leader_branch_creation: |
      **リーダーによるブランチ作成:**
      git checkout -b feature/task-{ID}-{機能}
      git push -u origin feature/task-{ID}-{機能}
      
    implementation_engineer: |
      **Implementation Engineerへの指示:**
      
      重要: まず以下のファイルを読み込んでください:
        - @.ai-framework/workflow_phase_3_parallel_implementation.md
        - @.ai-framework/05_practical_agent_communication_system.md
      
      役割: メイン実装担当
      タスク: TASK-{ID}（{機能名}）
      ブランチ: feature/task-{ID}-{機能}（リーダーが作成済み）
      
      作業内容:
      1. 設計ドキュメント作成（.ai/design/task_{ID}_design.md）
      2. TDD統合実装（Red → Green → Refactor）
      3. 実装完了後、リーダーに報告
      
      注意: コミットもpushもリーダーが行います。
      設計ドキュメント作成後、他のエンジニアに共有してください。
    
    quality_engineer: |
      **Quality Engineerへの指示:**
      
      役割: テスト・品質担当
      
      作業内容:
      1. Implementation Engineerの設計ドキュメントをレビュー（技術品質観点）
      2. 追加テストケース作成（E2E・統合・エッジケース）
      3. パフォーマンステスト実装
      4. セキュリティ観点でのレビュー
    
    documentation_engineer: |
      **Documentation Engineerへの指示:**
      
      役割: レビュー支援・ドキュメント担当
      
      作業内容:
      1. Implementation Engineerの設計ドキュメントをレビュー（保守性観点）
      2. 実装解説ドキュメント作成
      3. レビューガイド作成
      4. APIドキュメント・ユーザーガイド作成

  step_3_confirmation:
    - 各エンジニアエージェントからの「作業開始しました」確認を待つ
    - 確認完了後、並列実装フェーズに移行
    - "全エンジニアエージェントへのタスク分配が完了しました。並列実装を開始してください。"

completion_criteria:
  - リーダーがfeatureブランチ作成・push完了
  - 全エンジニアエージェントがタスク受諾・確認済み
  - 作業開始確認済み

next_steps:
  - Step 3-2: TDD並列実装実行開始
```

### **Step 3-2: 協業実装実行** 🤖🤝🤖
```yaml
トリガー: Step 3-1完了・全エージェント役割確認
実行者: エンジニアエージェント（協業）

ENGINEER_AGENT_IDENTITY:
engineer_identity:
  implementation_engineer: "私はImplementation Engineerです。TASK-{ID}のメイン実装を担当します"
  quality_engineer: "私はQuality Engineerです。TASK-{ID}のテスト・品質を担当します"
  documentation_engineer: "私はDocumentation Engineerです。TASK-{ID}のレビュー支援・ドキュメントを担当します"

role_clarity:
  implementation_engineer: "設計・TDD実装・統合を主導します"
  quality_engineer: "品質保証・追加テスト・技術レビューを担当します"
  documentation_engineer: "ドキュメント作成・保守性レビューを担当します"

CRITICAL_TDD_WORKFLOW:
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
    - 設計改善・リファクタリング

  detailed_design_refinement:
    - 実装中の詳細設計課題発見・調整
    - 基本設計では見えなかった技術的制約への対応
    - コンポーネント間インターフェースの詳細化
    - セキュリティ観点での設計調整
    - 実装知見に基づく設計改善提案

collaborative_implementation_flow:
  phase_1_design_documentation:
    implementation_engineer_tasks:
      - 設計ドキュメント作成: .ai/design/task_{ID}_design.md
      - 技術選定理由・アーキテクチャ説明
      - 実装方針・インターフェース定義
      - 他エンジニアへの共有: "**全エンジニアへの連絡:** 設計ドキュメントを作成しました。レビューをお願いします。"
    
  phase_2_design_review:
    quality_engineer_review:
      focus: "技術品質・テスタビリティ観点"
      checklist:
        - テスト可能な設計か
        - エラーハンドリング適切か
        - パフォーマンス考慮
        - セキュリティリスク
      feedback: "設計ドキュメントの技術品質セクションにコメント追加"
    
    documentation_engineer_review:
      focus: "保守性・ドキュメント観点"
      checklist:
        - 既存システムとの整合性
        - 命名規則・規約準拠
        - ドキュメント必要箇所
        - 将来の拡張性
      feedback: "設計ドキュメントの保守性セクションにコメント追加"
  
  phase_3_parallel_work:
    implementation_engineer_work:
      - TDD実装（Red → Green → Refactor）
      - メイン機能の統合実装
      - 単体テスト作成
      - コミット戦略遵守
    
    quality_engineer_work:
      - E2Eテストケース作成
      - エッジケーステスト追加
      - パフォーマンステスト実装
      - セキュリティテスト作成
    
    documentation_engineer_work:
      - 実装解説ドキュメント作成
      - レビューガイド作成
      - APIドキュメント更新
      - ユーザーガイド作成
  
  phase_4_integration:
    leader_activities:
      - 全エンジニアの作業完了確認
      - 最終的なgit push実行
      - 統合PR作成（全エンジニアの成果物含む）
      - Documentation EngineerのレビューガイドをPR説明に添付
    
    engineer_activities:
      - ローカルでのコミット完了
      - 成果物の最終確認
      - リーダーへの完了報告

design_coordination:
  real_time_communication:
    - 実装中の設計課題・変更提案の即座共有
    - 他エージェントへの影響評価・調整
    - 共通コンポーネント・インターフェース変更の協議
  
  design_update_process:
    - 重要な設計変更はリーダーエージェントに報告
    - ユーザー判断が必要な場合の適切なエスカレーション
    - 設計変更の文書化・共有

PROGRESS_REPORTING_PROTOCOL:
  regular_updates:
    format: "**LEADERへの進捗報告:** Issue #{番号} - {進捗状況}"
    frequency: "重要なマイルストーン達成時"
    content: "Red/Green/Refactorフェーズの進捗・課題・完了予定"

  completion_notification:
    format: "**LEADERへの完了報告:** TASK-{ID} - 実装完了・コミット済み・push待ち"
    required_info: "コミット数・テスト結果・次タスク受付可能"
    post_report_status: "リーダーにpushとPR作成を依頼"

COLLABORATIVE_COMMIT_STRATEGY:
  leader_commits_only:
    principle: "全てのコミットはリーダーエージェントが実行"
    
    engineer_reports:
      implementation_engineer:
        - "設計ドキュメント完成: .ai/design/task_{ID}_design.md"
        - "Red Phase完了: テストファイル一覧とコミットメッセージ案"
        - "Green Phase完了: 実装ファイル一覧とコミットメッセージ案"
        - "Refactor Phase完了: 変更ファイル一覧とコミットメッセージ案"
      
      quality_engineer:
        - "追加テスト完了: テストファイル一覧"
        - "コミットメッセージ案: test: TASK-{ID} - E2E・統合テスト追加"
      
      documentation_engineer:
        - "ドキュメント完了: ドキュメントファイル一覧"
        - "コミットメッセージ案: docs: TASK-{ID} - 実装解説・レビューガイド作成"
    
    leader_commit_flow:
      - "エンジニアから報告を受ける"
      - "git add [報告されたファイルのみ] # 重要: 他のエンジニアの作業中ファイルは含めない"
      - "git commit -m \"[エンジニア提案のメッセージ]\""
      - "各エンジニアの作業単位で個別にコミット（混在を防ぐ）"
      - "全エンジニアの作業完了後、git push origin feature/task-{ID}-{機能名}"
    
    commit_timing_rules:
      - "Implementation Engineerの各フェーズ完了時にコミット"
      - "Quality Engineerのテスト追加完了時に別途コミット"
      - "Documentation Engineerのドキュメント完了時に別途コミット"
      - "ファイル指定は必ず明示的に行う（例: git add src/auth.ts tests/auth.test.ts）"
      - "git add . は使用禁止（他エンジニアの作業が混入する恐れ）"

completion_criteria:
  - 各Issue実装完了次第、即座にPR作成・報告
  - 単体テスト成功
  - PR作成済み（適切なコミット履歴含む）
  - LEADERに完了報告済み

next_steps:
  - Step 3-3: 逐次PRレビュー・マージフロー開始
```

### **Step 3-3: 統合PRレビュー・マージフロー** 🤖🤝✅
```yaml
トリガー: チーム全体の機能実装完了・統合PR作成
実行者: Implementation Engineer（統合PR作成）→ AI自動レビューツール・ユーザー（レビュー）→ LEADERエージェント（マージ実行）

CRITICAL_PRINCIPLE: 1機能1PR・高品質レビュー
基本原則:
  - チーム全体の成果物を1つのPRに統合
  - engineer-3作成のレビューガイドで効率的レビュー
  - AI自動レビューツールとユーザーレビューの負荷軽減
  - 品質向上による手戻り削減
  - 1機能完了後、次の機能開発へ移行

collaborative_review_flow:
  step_1_integration:
    - リーダーが全エンジニアの成果物を確認
    - git push origin feature/task-{ID}-{機能}
    - PR作成（レビューガイド添付）
  
  step_2_efficient_review:
    pr_description: |
      ## TASK-{ID}: {機能名}
      
      ### 実装概要
      [Implementation Engineerによる実装サマリー]
      
      ### レビューガイド（by Documentation Engineer）
      - 重点確認ポイント
      - 想定Q&A
      - 関連ドキュメントリンク
      
      ### テストカバレッジ（by Quality Engineer）
      - 単体テスト: XX%
      - 統合テスト: 実装済み
      - E2Eテスト: 実装済み
  
  step_3_review_process:
    - AI自動レビュー（品質・セキュリティ）
    - ユーザーレビュー（レビューガイド参照で効率化）
    - フィードバック対応（チーム全体で分担）
  
  step_4_merge:
    - レビュー承認後、LEADERにマージ依頼
    - mainブランチへマージ
    - タスクファイルのステータス更新

COLLABORATIVE_PR_EXAMPLE:
  task_001_auth_feature:
    # チーム協業による認証機能実装
    engineer_reports:
      - implementation: "**LEADERへの報告:** TASK-001 TDD実装完了。15コミット。pushをお願いします。"
      - quality: "**LEADERへの報告:** TASK-001 E2Eテスト完了。8コミット。"
      - documentation: "**LEADERへの報告:** TASK-001 ドキュメント完了。5コミット。"
    leader_actions:
      - "git push origin feature/task-001-auth"
      - "gh pr create --base main --title 'TASK-001: 認証機能' --body '...'"
    merge_notification: "**全エンジニアへの通知:** TASK-001マージ完了。次はTASK-002を開始します。"

  case_2_dependent_feature:
    # 依存機能（データ管理機能）- 認証機能との統合確認必要
    engineer_report: "**LEADERへの報告:** Issue #2（データ管理機能）実装完了。PR #2作成済み。AI自動レビューツール・ユーザーレビュー依頼中。"
    review_completion: "AI自動レビューツール・ユーザーレビュー承認完了。認証機能との統合確認必要。"
    user_merge_request: "**engineer-2への通知:** PR #2のレビューが承認されました。リーダーへ報告してください。"
    engineer_response: "**LEADERへの確認:** レビュー承認されました・次タスク受付可能状態"
    leader_response: "**engineer-2への通知:** Issue #2 - レビュー承認を確認。認証機能との統合確認後マージします。次タスクとして Issue #{番号}を実施してください。"
    leader_response: "**統合テスト・マージ実行:** PR #2統合テスト成功。mainブランチにマージしました。Issue #2を閉じます。"
    # Issue閉じる処理: gh issue close {Issue番号} --comment "PR #{PR番号}でマージ完了。統合テスト成功・レビュー承認済み。"

  case_3_integration_feature:
    # 高依存機能（API統合機能）- 複数機能との統合確認必要
    engineer_report: "**LEADERへの報告:** Issue #3（API統合機能）実装完了。PR #3作成済み。AI自動レビューツール・ユーザーレビュー依頼中。"
    review_completion: "AI自動レビューツール・ユーザーレビュー承認完了。認証・データ管理機能との統合確認必要。"
    user_merge_request: "**engineer-3への通知:** PR #3のレビューが承認されました。リーダーへ報告してください。"
    engineer_response: "**LEADERへの確認:** レビュー承認されました・次タスク受付可能状態"
    leader_response: "**engineer-3への通知:** Issue #3 - レビュー承認を確認。全依存機能との統合確認後マージします。次タスクとして Issue #{番号}を実施してください。"
    leader_response: "**包括的統合テスト・マージ実行:** PR #3全依存機能との統合テスト成功。mainブランチにマージしました。Issue #3を閉じます。"
    # Issue閉じる処理: gh issue close {Issue番号} --comment "PR #{PR番号}でマージ完了。全依存機能との統合テスト成功・レビュー承認済み。"

マージ判定基準:
  independent_features:
    - 他機能に依存しない独立機能
    - レビュー承認後即座マージ可能
    - 例: 認証機能、ログ機能、設定機能
  
  dependent_features:
    - 他機能のAPIやデータに依存する機能
    - 依存先機能のマージ後に統合テスト実行
    - 統合テスト成功後マージ
    - 例: データ管理機能（認証依存）、レポート機能（データ管理依存）
  
  integration_features:
    - 複数機能を統合する機能
    - 全依存機能のマージ後に包括的統合テスト実行
    - 包括的統合テスト成功後マージ
    - 例: API統合機能、フロントエンド統合機能

マージ優先順位:
  - 独立機能のPR（レビュー承認後即座処理）
  - 依存機能のPR（依存先マージ後・統合テスト後処理）
  - 統合機能のPR（全依存先マージ後・包括的統合テスト後処理）

CRITICAL_ISSUE_MANAGEMENT:
  issue_closing_protocol:
    - PRマージ完了後、必ず対応するIssueを閉じる
    - Issue閉じる際は適切なコメントを追加（レビュー承認情報含む）
    - コマンド例: gh issue close {Issue番号} --comment "PR #{PR番号}でマージ完了。AI自動レビューツール・ユーザーレビュー承認済み。"
    - 全Issueが適切に閉じられていることを確認

completion_criteria:
  - 機能ごとの実装完了・統合PR作成済み
  - チーム全体での品質保証完了
  - レビューガイドによる効率的レビュー実施
  - 統合テスト成功
  - mainブランチにマージ完了
  - 次機能の開発準備完了

next_steps:
  - LEADERエージェント: "全Issue実装完了・AI自動レビューツール・ユーザーレビュー承認済み・依存関係に応じた逐次マージ完了。mainブランチに全機能統合済み"
  - LEADERエージェント: "MANDATORY: Phase 3完了。次フェーズへの移行指示のため、@.ai-framework/04_multi_agent_operational_workflow.md をリーダーエージェントに読み込ませてください。"
  - Phase 4: 最終レビュー・品質確認・プロジェクト完了
```

---

## 🎯 重要な制約・注意事項

### **CRITICAL RULE: リーダーエージェントは実装しない**
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
- **前フェーズ**: @.ai-framework/workflow_phase_2_task_breakdown.md
- **次フェーズ**: @.ai-framework/workflow_phase_4_review_integration.md
- **通信システム**: @.ai-framework/05_practical_agent_communication_system.md

## 🚀 実行方法
```bash
# Phase 3専用スクリプトを使用
./scripts/phase3-start.sh

# これにより:
# 1. tmuxセッション「agents」が作成される
# 2. 4分割でLEADER + Implementation/Quality/Documentation Engineerが起動
``` 