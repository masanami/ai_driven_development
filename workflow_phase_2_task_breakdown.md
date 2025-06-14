# Phase 2: タスク分割・GitHub Issues作成ワークフロー

## 🎯 フェーズ概要
**目的**: 基本設計をもとに実装可能なタスクに分割し、GitHub Issuesを作成する
**担当**: リーダーエージェント（メイン）+ QAエージェント（並列）
**完了条件**: GitHub Issues作成完了 + E2Eテスト設計完了

## 📋 GitHub Flow設定
**ブランチ戦略**: 
- **mainブランチ**: 統合・本番対応ブランチ
- **feature/issue-{番号}-{機能名}**: 各Issue対応の機能ブランチ
- **git worktree**: ../issue-{番号}-{機能名} ディレクトリで並列開発
- **PR戦略**: Issue完了次第、即座にPR作成・レビュー依頼

---

## 📋 実行チェックリスト

### **Step 2-1: E2Eテスト設計** 🤖 (並列実行開始)
```yaml
トリガー: Phase 1完了 + ユーザーのPhase 2開始指示
実行者: リーダーエージェント → QAエージェントに指示

前提条件:
  - エージェント環境起動済み（agents tmuxセッション稼働中）
  - QAエージェント起動済み（agents tmuxセッション pane 4）
  - 基本設計書・API仕様書確認済み

🚨 LEADER ACTIONS:
  1. QAエージェントにE2Eテスト設計を指示
  2. "./ai-framework/scripts/agent-send.sh qa-agent 'qa-agentへの指示: E2Eテスト設計を開始してください。基本設計書とAPI仕様書を参照して、包括的なテストシナリオを作成してください。'"
  3. QAエージェントの作業開始を確認

🚨 QA AGENT ACTIONS (リーダーエージェントからの指示を受けて実行):
  1. ユーザーシナリオベースのE2Eテスト設計
  2. 機能間連携テストシナリオ作成
  3. 異常系・エラーハンドリングテスト設計
  4. パフォーマンス・負荷テストシナリオ作成
  5. E2Eテストコード実装
  6. テストデータ・フィクスチャ作成
  7. テスト環境セットアップスクリプト作成
  8. CI/CD統合用テストスクリプト作成
  9. ブラウザ自動化テスト環境構築
  10. API統合テスト環境構築
  11. テスト実行・レポート生成システム構築

✅ 完了判定:
  - E2Eテストシナリオ仕様書作成済み
  - E2Eテストコード（実装済み）
  - テストデータセット・フィクスチャ作成済み
  - テスト環境構築スクリプト作成済み
  - CI/CD統合用テストスクリプト作成済み

🔄 次ステップ:
  - QAエージェント: "./ai-framework/scripts/agent-send.sh leader 'LEADERへの報告: E2Eテスト設計・実装完了しました。'"
  - リーダーエージェント: QAエージェントからの完了報告を確認
```

### **Step 2-2: タスク分割・GitHub Issues作成** 🤖 (並列実行)
```yaml
トリガー: Phase 1完了 + ユーザーのタスク分割指示
実行者: リーダーエージェント

前提条件:
  - エージェント環境起動済み（agents tmuxセッション稼働中）
  - .ai/knowledge_base/設計書一式確認済み

🚨 CRITICAL CHECKPOINT: 必ず2段階実行
phase_1_task_breakdown:
  1. 機能要求を親タスクに分割
  2. 親タスクを適度な粒度の子タスクに分解
  3. タスク間の依存関係を分析
  4. 並列実行可能なタスクを特定
  5. タスク優先度付け
  6. タスク分割ファイル作成（.ai/tasks/）
  7. "タスク分割が完了しました。続いてGitHub Issuesを作成します"

🛑 MANDATORY STEP: GitHub Issues作成は必須実行
phase_2_github_issues_creation:
  1. 各タスクごとにGitHub Issue作成を実行
  2. Issue作成結果の確認・報告
  3. 作成失敗時は再実行
  4. 全Issue作成完了まで継続
  5. "GitHub Issues作成が完了しました。エンジニアエージェントへのタスク分配準備完了です"

GitHub Issue テンプレート:
  title: "[TASK] {機能名} - {タスク概要}"
  body: |
    ## 📋 タスク概要
    {詳細な要件説明}
    
    ## ✅ 受け入れ基準
    - [ ] {基準1}
    - [ ] {基準2}
    - [ ] {基準3}
    
    ## 🔗 依存関係
    - 依存Issue: #{依存するIssue番号}
    
    ## 📝 実装メモ
    {技術的な留意点}
  labels: ["feature", "priority-{high/medium/low}", "area-{frontend/backend/api}"]

✅ 完了判定:
  - タスク分割ファイル作成済み
  - GitHub Issues作成済み（各タスク）
  - Issue番号一覧表作成済み

🔄 次ステップ:
  - "GitHub Issues作成完了。エンジニアエージェントへのタスク分配準備完了"
  - **🛑 STOP POINT: 実装フェーズには進まない**
  - ユーザーから「エンジニアエージェントにタスクを分配してください」指示を待つ
```

---

## 🎯 重要な制約・注意事項

### **リーダーエージェントの役割制限**
- **Phase 2では実装は絶対に行わない**
- **タスク分割・Issue作成・調整のみ**
- **GitHub Issues作成は必須実行項目**

### **🛑 STOP POINT: 実装フェーズには進まない**
```yaml
strict_rule: "リーダーエージェントは実装を行わない"
next_phase_trigger: "GitHub Issues作成完了後、ユーザーの明示的なタスク分配指示を待つ"
user_instruction_required: "「エンジニアエージェントにタスクを分配してください」のユーザー指示"
```

### **フェーズ移行ルール**
- **Phase 2完了後、必ずユーザー確認を取る**
- **自動的にPhase 3に進まない**
- **ユーザーから「Phase 3に進んでください」+ workflow_phase_3_parallel_implementation.md読み込み指示を待つ**

---

## 🔗 関連ドキュメント
- **前フェーズ**: workflow_phase_1_requirements_design.md
- **次フェーズ**: workflow_phase_3_parallel_implementation.md
- **エージェント通信**: 08_practical_agent_communication_system.md (Phase 3で必要) 