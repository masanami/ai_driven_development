# マルチエージェント開発ワークフロー マスターガイド

## 🎯 概要
フェーズ別に分割されたワークフローファイルの統合ガイド。
各フェーズ移行時に適切なファイルを読み込むことで、コンテキスト容量問題を解決し、エージェント間通信を正常化します。

---

## 🗂️ フェーズ別ファイル構成

```
workflow_master_guide.md                    ← 👆 このファイル（全体管理）
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
  2. ユーザー: "@workflow_phase_2_task_breakdown.md を読み込んでPhase 2を開始してください"
読み込みファイル: workflow_phase_2_task_breakdown.md
```

### **Phase 2 → Phase 3 移行**
```yaml
条件: Phase 2完了・GitHub Issues作成完了
移行指示:
  1. リーダーエージェント: "GitHub Issues作成完了。エンジニアエージェントへのタスク分配準備完了"
  2. ユーザー: "@workflow_phase_3_parallel_implementation.md と @08_practical_agent_communication_system.md を読み込んでPhase 3を開始してください"
読み込みファイル: 
  - workflow_phase_3_parallel_implementation.md
  - 08_practical_agent_communication_system.md
```

### **Phase 3 → Phase 4 移行**
```yaml
条件: Phase 3完了・全エンジニアエージェントPR作成完了
移行指示:
  1. 各エンジニアエージェント: "LEADERへの完了報告: Issue #{番号} - 実装完了・PR作成済み"
  2. ユーザー: "@workflow_phase_4_review_integration.md を読み込んでPhase 4を開始してください"
読み込みファイル: workflow_phase_4_review_integration.md
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

## 📋 実用的な実行手順

### **プロジェクト開始時**
```bash
# 1. エージェント環境構築（Phase 3前に実行推奨）
./ai-framework/scripts/quick-start.sh

# 2. Phase 1開始
# リーダーエージェントに以下を指示:
"@workflow_phase_1_requirements_design.md を読み込んで新規プロジェクトのPhase 1を開始してください"
```

### **各フェーズ移行時**
```yaml
Phase_1_完了後:
  user_action: "@workflow_phase_2_task_breakdown.md を読み込んでPhase 2を開始してください"

Phase_2_完了後:
  user_action: "@workflow_phase_3_parallel_implementation.md と @08_practical_agent_communication_system.md を読み込んでPhase 3を開始してください"
  note: "エージェント間通信が本格化するフェーズ"

Phase_3_完了後:
  user_action: "@workflow_phase_4_review_integration.md を読み込んでPhase 4を開始してください"

Phase_4_完了後:
  result: "プロジェクト完了・引き渡し"
```

---

## 🎯 コンテキスト最適化の効果

### **解決される問題**
✅ **コンテキスト容量オーバー**
- 各フェーズファイルは100-300行程度に最適化
- 不要な情報を排除し、実行に必要な情報のみ含有

✅ **エージェント間通信の失敗**
- Phase 3で通信プロトコルを重点的に再学習
- 具体的な通信フォーマット・手順を明記

✅ **フェーズ移行時の混乱**
- 明確な完了条件・移行手順
- ユーザートリガーによる確実な制御

✅ **役割認識の曖昧さ**
- 各フェーズでの担当・責任範囲を明確化
- 実行チェックリストによる具体的指示

### **実用性の向上**
🚀 **段階的学習**: 必要な時に必要な情報のみ提供
🚀 **確実な実行**: チェックリスト形式による漏れ防止
🚀 **エラー回避**: フェーズ境界での確認・承認による安全性
🚀 **保守性**: 各フェーズの独立性による管理容易性

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