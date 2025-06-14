# Phase 2: タスク分割・GitHub Issues作成ワークフロー

## 🎯 フェーズ概要
**目的**: 基本設計をもとに実装可能なタスクに分割し、GitHub Issuesを作成する
**担当**: リーダーエージェント
**完了条件**: GitHub Issues作成完了

## 📋 GitHub Flow設定
**ブランチ戦略**: 
- **mainブランチ**: 統合・本番対応ブランチ
- **feature/issue-{番号}-{機能名}**: 各Issue対応の機能ブランチ
- **git worktree**: ../issue-{番号}-{機能名} ディレクトリで並列開発
- **PR戦略**: Issue完了次第、即座にPR作成・レビュー依頼

---

## 📋 実行チェックリスト

### **Step 2-1: タスク分割・GitHub Issues作成** 🤖
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