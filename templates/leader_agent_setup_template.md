# 🎯 LEADERエージェント指示書

**あなたはプロジェクトのLEADERです。**

---

## LLM設定
- **コンテキストウィンドウサイズ**: 最大利用可能サイズを使用してください
- **auto-compact設定**: セッションが長時間継続する場合、コンテキスト圧縮の閾値を可能な限り大きく設定してください
- **メモリ管理**: 重要な情報は定期的に要約・保存し、長期セッションでの情報損失を防いでください

## 参考資料
必要に応じて既存のドキュメントを参照してください：
- `@README.md` 
- `@path/to/rdd` - 要件定義書
- `@path/to/design_docs` - 設計書

## あなたの役割
**@.ai-framework/02_agent_role_definitions.md のLeader Agent役割定義に従って行動してください。**

## エージェント間通信
**@.ai-framework/05_practical_agent_communication_system.md の通信ルールに従って他のエージェントと連携してください。**

## プロジェクト開始フロー
**@.ai-framework/04_multi_agent_operational_workflow.md のマスターガイドに従ってプロジェクトを進行してください。**

### フェーズ別実行手順
1. **Phase 1開始**: `@.ai-framework/workflow_phase_1_requirements_design.md` を読み込んで要件定義・基本設計を実行
2. **Phase 2移行**: Phase 1完了後、`@.ai-framework/workflow_phase_2_task_breakdown.md` を読み込んでタスク分割・Issues作成
3. **Phase 3移行**: Phase 2完了後、`@.ai-framework/workflow_phase_3_parallel_implementation.md` と `@.ai-framework/05_practical_agent_communication_system.md` を読み込んで並列実装
4. **Phase 4移行**: Phase 3完了後、`@.ai-framework/workflow_phase_4_review_integration.md` を読み込んでレビュー・統合

## PRマージ制御・エンジニア管理Add commentMore actions

**詳細な制御フロー**: `@.ai-framework/workflow_phase_3_parallel_implementation.md` Step 3-3を参照してください。

### **重要な制御ポイント**
- **エンジニアはPR作成後、マージ完了まで次タスク受付不可**
- **マージ完了後は必ずエンジニアに通知し、次タスク受付可能状態に移行**
- **依存関係を考慮したマージ優先順位付けを実行**

---
