# マルチエージェント開発ワークフロー マスターガイド

## 🎯 概要
フェーズ別に分割されたワークフローファイルの統合ガイド。
各フェーズ移行時に適切なファイルを読み込むことで、コンテキスト容量問題を解決し、エージェント間通信を正常化します。

---

## 🗂️ フェーズ別ファイル構成

```
06_multi_agent_operational_workflow.md      ← 👆 このファイル（全体管理）
├── workflow_phase_1_requirements_design.md ← Phase 1: 要件定義・基本設計
├── workflow_phase_2_task_breakdown.md      ← Phase 2: タスク分割・Issues作成
├── workflow_phase_3_parallel_implementation.md ← Phase 3: 並列実装・通信
├── workflow_phase_4_review_integration.md  ← Phase 4: レビュー・統合・完了
└── workflow_existing_project_integration.md ← 既存プロジェクト統合
```

---

## 🔄 フェーズ移行プロトコル

### **Phase 1 → Phase 2 移行**
```yaml
条件: Phase 1完了・ユーザー承認済み基本設計書作成
移行指示: 
  1. リーダーエージェント: "Phase 1完了。Phase 2へ移行準備完了"
  2. リーダーエージェント: "🚨 MANDATORY: Phase 2のタスク分割を開始するため、リーダーエージェントに @ai-framework/workflow_phase_2_task_breakdown.md を読み込ませてください。"
  3. ユーザー: "@ai-framework/workflow_phase_2_task_breakdown.md を読み込んでPhase 2を開始してください"
読み込みファイル: workflow_phase_2_task_breakdown.md
```

### **Phase 2 → Phase 3 移行**
```yaml
条件: Phase 2完了・GitHub Issues作成完了
移行指示:
  1. リーダーエージェント: "GitHub Issues作成完了。エンジニアエージェントへのタスク分配準備完了"
  2. リーダーエージェント: "🚨 MANDATORY: Phase 3の並列実装を開始するため、リーダーエージェントに @ai-framework/workflow_phase_3_parallel_implementation.md と @ai-framework/08_practical_agent_communication_system.md を読み込ませてください。"
  3. ユーザー: "@ai-framework/workflow_phase_3_parallel_implementation.md と @ai-framework/08_practical_agent_communication_system.md を読み込んでPhase 3を開始してください"
読み込みファイル: 
  - workflow_phase_3_parallel_implementation.md
  - 08_practical_agent_communication_system.md
```

### **Phase 3 → Phase 4 移行**
```yaml
条件: Phase 3完了・全Issue実装完了・逐次PR作成・マージ完了
移行指示:
  1. LEADERエージェント: "全Issue実装完了・依存関係に応じた逐次マージ完了。mainブランチに全機能統合済み"
  2. LEADERエージェント: "🚨 MANDATORY: Phase 4の最終レビュー・統合を開始するため、リーダーエージェントに @ai-framework/workflow_phase_4_review_integration.md を読み込ませてください。"
  3. ユーザー: "@ai-framework/workflow_phase_4_review_integration.md を読み込んでPhase 4を開始してください"
読み込みファイル: workflow_phase_4_review_integration.md
注記: Phase 3で逐次PR作成・レビュー・マージが完了しているため、Phase 4は最終品質確認・プロジェクト完了処理
```

---

## 🚨 重要な実行ルール

### **1. 各フェーズでの必須読み込み**
- **Phase開始前に必ず該当ファイルを読み込む**
- **エージェント間通信が必要なPhase 3では08_practical_agent_communication_system.mdも同時読み込み**
- **前フェーズの情報は引き継がれないものとして扱う**

### **2. フェーズ境界での停止ポイント**
- **各フェーズ完了後は必ずユーザー確認を求める**
- **自動的に次フェーズに進まない**
- **ユーザーの明示的な次フェーズ開始指示を待つ**

### **3. エージェント役割の明確化**
- **各フェーズで担当エージェントが明確**
- **Phase 3のみマルチエージェント体制**
- **リーダーエージェントは実装を行わない**


---

## 🔗 関連ドキュメント
- **元ファイル**: 06_multi_agent_operational_workflow.md（参考用・非実行用）
- **通信システム**: 08_practical_agent_communication_system.md（Phase 3で重要）
- **フレームワーク全体**: README.md・USAGE.md

---

## 📝 運用メモ
- **このマスターガイドは概要把握用**
- **実際の実行は各Phase専用ファイルを使用**
- **Phase移行時の読み込み指示は必須実行**
- **エージェント間通信問題の根本解決を目指す** 