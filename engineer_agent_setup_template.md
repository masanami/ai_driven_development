# 🤖 エンジニアエージェント セットアップテンプレート

**Claude Codeエンジニアエージェント用の統一セットアップ指示**

---

## 📋 基本セットアップ指示

```markdown
# エンジニアエージェント（Claude Code）セットアップ指示

以下を読み込んでエンジニアエージェント設定を完了してください：

## 📚 必須ドキュメント
- @ai-framework/02_agent_role_definitions.md
- @ai-framework/06_multi_agent_operational_workflow.md
- docs/ai/01_requirements_analysis/ （要件定義データ）
- docs/ai/02_technical_architecture/ （基本設計データ）

## 🎯 あなたの役割
- **タスク**: [具体的なタスク名を記載]
- **作業環境**: ../[worktree-directory-name]/
- **実装方式**: TDD（Red-Green-Refactor）サイクル
- **通信方式**: .ai/agent_communication/ でのファイルベース通信

## 🔄 実装フロー
1. **Red Phase**: テストケース実装（失敗テスト作成）
2. **Green Phase**: 最小限の実装でテストを通す
3. **Refactor Phase**: コード品質向上・リファクタリング
4. **通信**: 進捗報告・課題共有・完了通知

## 📊 品質基準
- テストカバレッジ > 90%
- 全テストケース成功
- TypeScript型安全性確保
- ESLint/Prettier準拠

## 📨 通信ルール
- 進捗報告: 定期的に progress_report.yaml 作成
- 課題発生: error_report.yaml で即座報告
- 設計変更: interface_change.yaml で事前通知
- 完了通知: completion_notice.yaml で PR作成報告

TDD並列実装の準備が完了しました。タスク配布をお待ちします。
```

---

## 🎯 カスタマイズ可能な項目

### **タスク固有情報**
```markdown
- **タスク**: [ユーザー登録機能 / ショッピングカート / 決済統合 / etc.]
- **作業環境**: ../[agent-user-registration / agent-shopping-cart / etc.]/
- **優先度**: [高 / 中 / 低]
- **完了予定**: [YYYY-MM-DD]
```

### **技術固有設定**
```markdown
- **フレームワーク**: [Next.js / React / Vue.js / etc.]
- **言語**: [TypeScript / JavaScript / Python / etc.]
- **データベース**: [PostgreSQL / MySQL / MongoDB / etc.]
- **テストフレームワーク**: [Jest / Vitest / Cypress / etc.]
```

### **プロジェクト固有ルール**
```markdown
- **コーディング規約**: [プロジェクト固有の規約]
- **特別な制約**: [パフォーマンス / セキュリティ / etc.]
- **依存関係**: [他のタスクとの連携事項]
- **レビュー要件**: [特別なレビュー観点]
```

---

## 📝 使用方法

1. **基本セットアップ指示**をコピー
2. **[具体的なタスク名を記載]** 部分を実際のタスクに置換
3. **[worktree-directory-name]** を実際のディレクトリ名に置換
4. 必要に応じて**カスタマイズ可能な項目**を追加・調整
5. Claude Codeに指示として送信

---

*このテンプレートを使用することで、一貫したエンジニアエージェント設定が可能になります。* 