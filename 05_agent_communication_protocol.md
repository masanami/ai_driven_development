# エージェント間コミュニケーション仕様書

## ⚠️ 適用範囲・対象ユーザー

### **🎯 対象システム**
本仕様書は以下のような**大規模・企業レベル**のAIシステムを対象としています：

- **複数のAIエージェントが24/7で協調動作**するシステム
- **数十〜数百のエージェント**が同時稼働する環境
- **企業のCI/CD、プロジェクト管理の完全自動化**システム
- **マルチテナント対応**のAIサービス基盤

### **❌ 個人利用・小規模スタートには不適用**
以下のような個人や小規模チームの開発環境では、**この仕様は完全にオーバースペック**です：

```yaml
個人・小規模チームの一般的な利用ケース:
  claude_code: "コード編集 + GitHub連携"
  claude_desktop: "情報検索 + 文書作成"  
  # ↑エージェント間通信は発生しない
  
小規模スタートでの推奨アプローチ:
  - 06_multi_agent_operational_workflow.md のファイルベース通信で十分
  - 04_tool_integration_specs.md のMCP統合で効率化
  - ACPシステムの構築は不要（オーバーエンジニアリング）
  - サーバーインフラも不要
```

### **📈 段階的拡張時の活用**
```yaml
適用タイミング:
  Phase1（1-5エージェント）: 06のファイルベース通信
  Phase2（5-10エージェント）: 部分的ACP機能検討
  Phase3（10+エージェント）: 本仕様の本格採用検討
  
移行判断指標:
  - エージェント数 > 10個
  - リアルタイム協調の必要性
  - 企業レベルの運用要件
  - インフラ投資の正当化
```

### **🏢 企業での実装例**
```yaml
想定される企業システム:
  開発チーム規模: 50-200人
  稼働エージェント数: 100-500個
  処理するプロジェクト数: 10-50個同時
  必要インフラ: Redis, PostgreSQL, Kubernetes等
  年間開発コスト: 数千万円規模
```

### **📚 本仕様書の学習価値**
小規模では実装不要ですが、以下の学習価値があります：
- **大規模AIシステム設計の理解**
- **分散システムアーキテクチャの参考**
- **将来的な企業システム開発への準備**

---

## 💬 概要

マルチエージェントシステムにおけるエージェント間のコミュニケーション、コンテキスト管理、競合解決のための包括的な仕様を定義します。
Agent Communication Protocol (ACP) を基盤とし、効率的で信頼性の高いエージェント協調を実現します。

**⚠️ 注意**: 小規模スタート（1-5エージェント）では、`06_multi_agent_operational_workflow.md`のファイルベース通信システムを強く推奨します。

---

## 🔄 コミュニケーションアーキテクチャ

### 通信モデル

#### 🌐 分散型メッセージング
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ PM Agent    │◄──►│ Message Bus │◄──►│Engineer     │
│             │    │             │    │Agent        │
└─────────────┘    └─────────────┘    └─────────────┘
       ▲                   ▲                   ▲
       │                   │                   │
       ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│QA Agent     │◄──►│ ACP Router  │◄──►│Frontend     │
│             │    │             │    │Agent        │
└─────────────┘    └─────────────┘    └─────────────┘
       ▲                   ▲                   ▲
       │                   │                   │
       ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Tech Writer  │◄──►│ Context DB  │◄──►│Backend      │
│Agent        │    │             │    │Agent        │
└─────────────┘    └─────────────┘    └─────────────┘
```

#### 📨 メッセージング仕様

##### **標準メッセージ形式**
```json
{
  "header": {
    "protocol_version": "2.0",
    "message_id": "msg-{uuid}",
    "timestamp": "2024-01-15T10:30:00.000Z",
    "ttl": 3600,
    "compression": "gzip",
    "encryption": "AES-256"
  },
  "routing": {
    "sender": {
      "agent_id": "pm-agent-001",
      "agent_type": "ProductManager",
      "framework": "langchain",
      "version": "1.2.0"
    },
    "recipient": {
      "agent_id": "engineer-agent-001",
      "agent_type": "SeniorEngineer", 
      "framework": "autogen",
      "version": "0.9.3"
    },
    "reply_to": "pm-agent-001",
    "correlation_id": "task-workflow-456"
  },
  "message": {
    "type": "task_assignment",
    "priority": "high",
    "requires_ack": true,
    "content": {
      "task_id": "TASK-123",
      "description": "Implement user authentication API",
      "requirements": ["OAuth2", "JWT", "Rate limiting"],
      "deadline": "2024-01-20T17:00:00Z",
      "dependencies": ["schema_migration_complete"],
      "acceptance_criteria": [
        "API returns 401 for invalid tokens",
        "Rate limiting at 100 req/min per user",
        "Support for refresh tokens"
      ]
    }
  },
  "metadata": {
    "workflow_step": 2,
    "total_steps": 7,
    "context_references": ["project-spec-v1.2", "auth-requirements"],
    "retry_count": 0,
    "max_retries": 3
  }
}
```

##### **メッセージタイプ定義**
```yaml
message_types:
  # タスク管理
  task_assignment:
    description: "新しいタスクの割り当て"
    required_fields: ["task_id", "description", "deadline"]
    sender_types: ["ProductManager"]
    recipient_types: ["Engineer", "QA", "TechWriter"]
  
  task_acceptance:
    description: "タスクの受諾確認"
    required_fields: ["task_id", "estimated_completion"]
    sender_types: ["Engineer", "QA", "TechWriter"]
    recipient_types: ["ProductManager"]
  
  progress_update:
    description: "進捗状況の更新"
    required_fields: ["task_id", "progress_percentage", "status"]
    sender_types: ["Engineer", "QA", "TechWriter"]
    recipient_types: ["ProductManager"]
    frequency: "every_2_hours"
  
  # コラボレーション
  code_review_request:
    description: "コードレビューの依頼"
    required_fields: ["pr_url", "review_type", "priority"]
    sender_types: ["Engineer"]
    recipient_types: ["SeniorEngineer", "QA"]
  
  knowledge_sharing:
    description: "知識・発見の共有"
    required_fields: ["topic", "content", "relevance"]
    sender_types: ["All"]
    recipient_types: ["All"]
  
  # 緊急時
  error_report:
    description: "エラー・障害の報告"
    required_fields: ["error_type", "severity", "affected_systems"]
    sender_types: ["All"]
    recipient_types: ["ProductManager", "SeniorEngineer"]
    priority: "critical"
  
  escalation:
    description: "問題のエスカレーション"
    required_fields: ["issue_id", "escalation_reason", "required_action"]
    sender_types: ["All"]
    recipient_types: ["ProductManager"]
    priority: "high"
```

---

## 🧠 コンテキスト管理システム

### 共有メモリアーキテクチャ

#### 📊 階層型メモリシステム
```python
class ContextManager:
    def __init__(self):
        self.short_term_memory = ShortTermMemory(ttl=3600)  # 1時間
        self.working_memory = WorkingMemory(ttl=86400)      # 24時間
        self.long_term_memory = LongTermMemory()            # 永続化
        self.shared_memory = SharedMemory()                 # エージェント間共有
    
    async def store_context(self, agent_id: str, context: dict, memory_type: str):
        """コンテキスト保存"""
        
        # タイムスタンプ付与
        context['timestamp'] = datetime.now()
        context['agent_id'] = agent_id
        
        if memory_type == "short_term":
            await self.short_term_memory.store(context)
        elif memory_type == "working":
            await self.working_memory.store(context)
        elif memory_type == "long_term":
            await self.long_term_memory.store(context)
        elif memory_type == "shared":
            await self.shared_memory.store(context)
            # 他エージェントに通知
            await self._notify_context_update(context)
    
    async def retrieve_context(self, agent_id: str, query: dict) -> list:
        """コンテキスト検索"""
        
        results = []
        
        # 各メモリから検索
        for memory in [self.short_term_memory, self.working_memory, 
                      self.long_term_memory, self.shared_memory]:
            matches = await memory.search(query)
            results.extend(matches)
        
        # 関連性でソート
        sorted_results = self._rank_by_relevance(results, query)
        
        return sorted_results[:10]  # 上位10件を返す
```

#### 🔍 コンテキスト検索システム
```python
class ContextSearchEngine:
    def __init__(self):
        self.vector_db = ChromaDB()
        self.keyword_index = ElasticSearch()
    
    async def semantic_search(self, query: str, agent_id: str) -> list:
        """セマンティック検索"""
        
        # クエリをベクトル化
        query_vector = await self._embed_query(query)
        
        # ベクトル検索実行
        similar_contexts = await self.vector_db.similarity_search(
            vector=query_vector,
            filter={"accessible_by": agent_id},
            limit=20
        )
        
        return similar_contexts
    
    async def keyword_search(self, keywords: list, agent_id: str) -> list:
        """キーワード検索"""
        
        search_query = {
            "bool": {
                "must": [
                    {"terms": {"keywords": keywords}},
                    {"term": {"accessible_by": agent_id}}
                ]
            }
        }
        
        results = await self.keyword_index.search(
            index="agent_contexts",
            body={"query": search_query}
        )
        
        return results["hits"]["hits"]
    
    async def hybrid_search(self, query: str, keywords: list, agent_id: str) -> list:
        """ハイブリッド検索"""
        
        # セマンティック検索とキーワード検索を並行実行
        semantic_results, keyword_results = await asyncio.gather(
            self.semantic_search(query, agent_id),
            self.keyword_search(keywords, agent_id)
        )
        
        # 結果をマージしてランキング
        merged_results = self._merge_and_rank(semantic_results, keyword_results)
        
        return merged_results
```

### メモリ戦略

#### 🗂️ コンテキスト分類システム
```yaml
context_categories:
  project_context:
    description: "プロジェクト全体に関わる文脈"
    retention_period: "project_duration"
    sharing_scope: "all_agents"
    examples:
      - "プロジェクト目標と要件"
      - "技術スタック決定理由"
      - "重要な設計決定"
  
  task_context:
    description: "特定タスクに関する文脈"
    retention_period: "task_completion + 30_days"
    sharing_scope: "task_participants"
    examples:
      - "タスク実行中の発見"
      - "技術的課題と解決策"
      - "テスト結果と品質指標"
  
  knowledge_context:
    description: "学習・発見した知識"
    retention_period: "permanent"
    sharing_scope: "relevant_agents"
    examples:
      - "ライブラリの使用方法"
      - "パフォーマンス最適化手法"
      - "デバッグテクニック"
  
  conversation_context:
    description: "エージェント間の会話履歴"
    retention_period: "7_days"
    sharing_scope: "conversation_participants"
    examples:
      - "過去の質問と回答"
      - "議論の流れ"
      - "合意事項"
```

#### 🔄 コンテキスト更新戦略
```python
class ContextUpdateManager:
    def __init__(self):
        self.update_strategies = {
            'project_context': ProjectContextUpdater(),
            'task_context': TaskContextUpdater(),
            'knowledge_context': KnowledgeContextUpdater(),
            'conversation_context': ConversationContextUpdater()
        }
    
    async def update_context(self, context_type: str, update_data: dict):
        """コンテキスト更新"""
        
        updater = self.update_strategies[context_type]
        
        # 更新前の状態を保存
        old_context = await self._get_current_context(context_type, update_data['id'])
        
        # 更新実行
        new_context = await updater.update(update_data)
        
        # 変更ログ記録
        await self._log_context_change(old_context, new_context)
        
        # 関連エージェントに通知
        await self._notify_relevant_agents(context_type, new_context)
        
        return new_context
    
    async def _notify_relevant_agents(self, context_type: str, context: dict):
        """関連エージェントへの通知"""
        
        # 通知対象エージェント特定
        relevant_agents = await self._find_relevant_agents(context_type, context)
        
        # 並行通知
        notification_tasks = [
            self._send_context_update_notification(agent_id, context)
            for agent_id in relevant_agents
        ]
        
        await asyncio.gather(*notification_tasks)
```

---

## ⚔️ 競合解決システム

### 競合検出

#### 🔍 競合シナリオ定義
```python
class ConflictDetector:
    def __init__(self):
        self.conflict_patterns = {
            'resource_conflict': ResourceConflictDetector(),
            'task_conflict': TaskConflictDetector(),
            'decision_conflict': DecisionConflictDetector(),
            'communication_conflict': CommunicationConflictDetector()
        }
    
    async def detect_conflicts(self, activity_stream: list) -> list:
        """競合検出"""
        
        detected_conflicts = []
        
        for detector_type, detector in self.conflict_patterns.items():
            conflicts = await detector.scan(activity_stream)
            for conflict in conflicts:
                conflict['type'] = detector_type
                conflict['detected_at'] = datetime.now()
                detected_conflicts.append(conflict)
        
        return detected_conflicts

class ResourceConflictDetector:
    async def scan(self, activities: list) -> list:
        """リソース競合検出"""
        conflicts = []
        
        # 同一リソースへの同時アクセス検出
        resource_access = {}
        for activity in activities:
            if activity['type'] == 'resource_access':
                resource_id = activity['resource_id']
                if resource_id not in resource_access:
                    resource_access[resource_id] = []
                resource_access[resource_id].append(activity)
        
        # 競合チェック
        for resource_id, accesses in resource_access.items():
            if len(accesses) > 1:
                # 時間重複チェック
                overlapping = self._find_time_overlaps(accesses)
                if overlapping:
                    conflicts.append({
                        'resource_id': resource_id,
                        'conflicting_agents': [a['agent_id'] for a in overlapping],
                        'conflict_time': overlapping[0]['start_time'],
                        'severity': 'medium'
                    })
        
        return conflicts
```

### 競合解決戦略

#### ⚖️ 階層型意思決定システム
```python
class ConflictResolver:
    def __init__(self):
        self.resolution_hierarchy = {
            'technical_decisions': 'senior-engineer-agent',
            'ux_decisions': 'frontend-agent', 
            'quality_standards': 'qa-agent',
            'project_priorities': 'pm-agent',
            'resource_allocation': 'pm-agent'
        }
        
        self.resolution_strategies = {
            'resource_conflict': ResourceConflictResolver(),
            'task_conflict': TaskConflictResolver(),
            'decision_conflict': DecisionConflictResolver()
        }
    
    async def resolve_conflict(self, conflict: dict) -> dict:
        """競合解決"""
        
        conflict_type = conflict['type']
        resolver = self.resolution_strategies[conflict_type]
        
        # 解決策生成
        resolution_options = await resolver.generate_options(conflict)
        
        # 意思決定者特定
        decision_maker = self._get_decision_maker(conflict)
        
        # 決定依頼
        resolution = await self._request_decision(
            decision_maker, 
            conflict, 
            resolution_options
        )
        
        # 解決策実行
        result = await self._execute_resolution(resolution)
        
        # 結果記録
        await self._log_resolution(conflict, resolution, result)
        
        return result
    
    def _get_decision_maker(self, conflict: dict) -> str:
        """意思決定者特定"""
        
        # 競合カテゴリに基づく判定
        conflict_category = self._categorize_conflict(conflict)
        
        return self.resolution_hierarchy.get(
            conflict_category, 
            'pm-agent'  # デフォルト
        )
```

#### 🗳️ 投票システム
```python
class VotingSystem:
    def __init__(self):
        self.voting_weights = {
            'pm-agent': 3.0,
            'senior-engineer-agent': 2.5,
            'frontend-agent': 2.0,
            'backend-agent': 2.0,
            'qa-agent': 2.0,
            'tech-writer-agent': 1.5
        }
    
    async def conduct_vote(self, issue: dict, eligible_voters: list) -> dict:
        """投票実施"""
        
        # 投票開始通知
        await self._notify_voting_start(issue, eligible_voters)
        
        # 投票期限設定（デフォルト：1時間）
        voting_deadline = datetime.now() + timedelta(hours=1)
        
        votes = []
        while datetime.now() < voting_deadline:
            # 投票収集
            new_votes = await self._collect_votes(issue['issue_id'])
            votes.extend(new_votes)
            
            # 全員投票完了チェック
            if len(votes) >= len(eligible_voters):
                break
            
            await asyncio.sleep(60)  # 1分間隔でチェック
        
        # 結果集計
        result = await self._tally_votes(votes)
        
        # 結果通知
        await self._notify_voting_result(issue, result)
        
        return result
    
    async def _tally_votes(self, votes: list) -> dict:
        """投票集計"""
        
        option_scores = {}
        total_weight = 0
        
        for vote in votes:
            agent_id = vote['agent_id']
            option = vote['option']
            weight = self.voting_weights.get(agent_id, 1.0)
            
            if option not in option_scores:
                option_scores[option] = 0
            
            option_scores[option] += weight
            total_weight += weight
        
        # パーセンテージ計算
        percentages = {
            option: (score / total_weight) * 100
            for option, score in option_scores.items()
        }
        
        # 勝者決定
        winner = max(option_scores.keys(), key=lambda k: option_scores[k])
        
        return {
            'winner': winner,
            'scores': option_scores,
            'percentages': percentages,
            'total_participants': len(votes),
            'total_weight': total_weight
        }
```

---

## 🐛 デバッグ・監視システム

### エージェント活動可視化

#### 📊 リアルタイムダッシュボード
```python
class AgentActivityDashboard:
    def __init__(self):
        self.websocket_server = WebSocketServer()
        self.activity_monitor = ActivityMonitor()
    
    async def start_monitoring(self):
        """監視開始"""
        
        # WebSocketサーバー起動
        await self.websocket_server.start(port=8080)
        
        # アクティビティ監視開始
        await self.activity_monitor.start_monitoring(
            callback=self._broadcast_activity_update
        )
    
    async def _broadcast_activity_update(self, activity: dict):
        """アクティビティ更新のブロードキャスト"""
        
        # ダッシュボード用データ変換
        dashboard_data = {
            'timestamp': activity['timestamp'],
            'agent_id': activity['agent_id'],
            'activity_type': activity['type'],
            'status': activity['status'],
            'details': activity.get('details', {}),
            'performance_metrics': {
                'response_time': activity.get('response_time'),
                'memory_usage': activity.get('memory_usage'),
                'cpu_usage': activity.get('cpu_usage')
            }
        }
        
        # 全接続クライアントに送信
        await self.websocket_server.broadcast(dashboard_data)
```

#### 🔍 デバッグツール
```python
class AgentDebugger:
    def __init__(self):
        self.conversation_logger = ConversationLogger()
        self.state_inspector = StateInspector()
        self.workflow_tracer = WorkflowTracer()
    
    async def debug_conversation(self, agent_id: str, conversation_id: str):
        """会話デバッグ"""
        
        # 会話履歴取得
        conversation = await self.conversation_logger.get_conversation(
            conversation_id
        )
        
        # 各メッセージの分析
        analysis = []
        for message in conversation['messages']:
            message_analysis = {
                'message_id': message['id'],
                'timestamp': message['timestamp'],
                'sender': message['sender'],
                'recipient': message['recipient'],
                'processing_time': message.get('processing_time'),
                'errors': message.get('errors', []),
                'context_used': message.get('context_references', []),
                'decisions_made': message.get('decisions', [])
            }
            analysis.append(message_analysis)
        
        return {
            'conversation_id': conversation_id,
            'total_messages': len(conversation['messages']),
            'duration': conversation['duration'],
            'participants': conversation['participants'],
            'message_analysis': analysis,
            'bottlenecks': self._identify_bottlenecks(analysis),
            'recommendations': self._generate_debug_recommendations(analysis)
        }
    
    async def inspect_agent_state(self, agent_id: str) -> dict:
        """エージェント状態検査"""
        
        state = await self.state_inspector.get_full_state(agent_id)
        
        return {
            'agent_id': agent_id,
            'current_tasks': state['active_tasks'],
            'memory_usage': state['memory'],
            'context_cache': state['context_cache'],
            'performance_metrics': state['metrics'],
            'recent_activities': state['recent_activities'],
            'error_log': state['errors'],
            'health_status': self._assess_agent_health(state)
        }
```

### エラーハンドリング

#### 🚨 エラー分類・対応システム
```python
class ErrorHandler:
    def __init__(self):
        self.error_classifiers = {
            'communication_error': CommunicationErrorHandler(),
            'context_error': ContextErrorHandler(), 
            'resource_error': ResourceErrorHandler(),
            'logic_error': LogicErrorHandler()
        }
        
        self.escalation_rules = {
            'critical': ['pm-agent', 'senior-engineer-agent'],
            'high': ['senior-engineer-agent'],
            'medium': ['originating-agent'],
            'low': ['log-only']
        }
    
    async def handle_error(self, error: dict) -> dict:
        """エラーハンドリング"""
        
        # エラー分類
        error_type = await self._classify_error(error)
        
        # 重要度評価
        severity = await self._assess_severity(error)
        
        # 適切なハンドラー選択
        handler = self.error_classifiers[error_type]
        
        # エラー処理実行
        resolution = await handler.handle(error)
        
        # エスカレーション判定
        if severity in ['critical', 'high']:
            await self._escalate_error(error, severity)
        
        # ログ記録
        await self._log_error_handling(error, resolution)
        
        return resolution
    
    async def _escalate_error(self, error: dict, severity: str):
        """エラーエスカレーション"""
        
        escalation_targets = self.escalation_rules[severity]
        
        escalation_message = {
            'type': 'error_escalation',
            'priority': 'critical',
            'content': {
                'error_id': error['id'],
                'error_type': error['type'],
                'severity': severity,
                'affected_systems': error['affected_systems'],
                'initial_handler': error['handler'],
                'resolution_attempted': error['resolution_attempted'],
                'additional_action_required': True
            }
        }
        
        # 並行エスカレーション
        escalation_tasks = [
            self._send_escalation_message(target, escalation_message)
            for target in escalation_targets
        ]
        
        await asyncio.gather(*escalation_tasks)
```

### パフォーマンス監視

#### 📈 メトリクス収集システム
```python
class PerformanceMonitor:
    def __init__(self):
        self.metrics_collector = MetricsCollector()
        self.anomaly_detector = AnomalyDetector()
        self.alert_manager = AlertManager()
    
    async def collect_agent_metrics(self, agent_id: str) -> dict:
        """エージェントメトリクス収集"""
        
        current_time = datetime.now()
        
        # 基本メトリクス
        basic_metrics = {
            'response_time': await self._measure_response_time(agent_id),
            'throughput': await self._measure_throughput(agent_id),
            'error_rate': await self._calculate_error_rate(agent_id),
            'memory_usage': await self._get_memory_usage(agent_id),
            'cpu_usage': await self._get_cpu_usage(agent_id)
        }
        
        # コミュニケーションメトリクス
        comm_metrics = {
            'messages_sent': await self._count_messages_sent(agent_id),
            'messages_received': await self._count_messages_received(agent_id),
            'average_message_size': await self._avg_message_size(agent_id),
            'conversation_efficiency': await self._calc_conversation_efficiency(agent_id)
        }
        
        # タスクメトリクス
        task_metrics = {
            'tasks_completed': await self._count_completed_tasks(agent_id),
            'tasks_in_progress': await self._count_active_tasks(agent_id),
            'average_task_duration': await self._avg_task_duration(agent_id),
            'task_success_rate': await self._calc_task_success_rate(agent_id)
        }
        
        all_metrics = {
            'agent_id': agent_id,
            'timestamp': current_time,
            'basic': basic_metrics,
            'communication': comm_metrics,
            'tasks': task_metrics
        }
        
        # 異常検知
        anomalies = await self.anomaly_detector.detect(all_metrics)
        if anomalies:
            await self.alert_manager.send_anomaly_alert(agent_id, anomalies)
        
        # メトリクス保存
        await self.metrics_collector.store(all_metrics)
        
        return all_metrics
```

---

## 🔧 実装ガイドライン

### メッセージルーター実装

#### 📮 ACPメッセージルーター
```python
class ACPMessageRouter:
    def __init__(self):
        self.agent_registry = AgentRegistry()
        self.message_queue = RedisMessageQueue()
        self.load_balancer = LoadBalancer()
        
    async def route_message(self, message: dict) -> dict:
        """メッセージルーティング"""
        
        try:
            # メッセージ検証
            await self._validate_message(message)
            
            # 受信者エージェント特定
            recipient = message['routing']['recipient']
            agent_instances = await self.agent_registry.find_agent_instances(
                recipient['agent_id']
            )
            
            if not agent_instances:
                raise AgentNotFoundError(f"Agent {recipient['agent_id']} not found")
            
            # ロードバランシング
            target_instance = await self.load_balancer.select_instance(
                agent_instances
            )
            
            # メッセージ配信
            delivery_result = await self._deliver_message(target_instance, message)
            
            # 配信確認要求の場合は確認待ち
            if message['message'].get('requires_ack'):
                ack = await self._wait_for_acknowledgment(
                    message['header']['message_id'],
                    timeout=30
                )
                delivery_result['acknowledgment'] = ack
            
            return delivery_result
            
        except Exception as e:
            # エラーハンドリング
            await self._handle_routing_error(message, e)
            raise
    
    async def _deliver_message(self, target_instance: dict, message: dict) -> dict:
        """メッセージ配信"""
        
        delivery_start = datetime.now()
        
        try:
            # メッセージキューに送信
            await self.message_queue.send(
                queue=target_instance['queue_name'],
                message=message
            )
            
            delivery_end = datetime.now()
            delivery_time = (delivery_end - delivery_start).total_seconds()
            
            return {
                'status': 'delivered',
                'delivery_time': delivery_time,
                'target_instance': target_instance['instance_id'],
                'timestamp': delivery_end
            }
            
        except Exception as e:
            return {
                'status': 'failed',
                'error': str(e),
                'timestamp': datetime.now()
            }
```

### セットアップガイド

#### ⚙️ 環境設定
```yaml
# docker-compose.yml for Agent Communication
version: '3.8'

services:
  acp-router:
    build: ./acp-router
    ports:
      - "8000:8000"
    environment:
      - REDIS_URL=redis://redis:6379
      - POSTGRES_URL=postgresql://acp:password@postgres:5432/acp_db
    depends_on:
      - redis
      - postgres

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: acp_db
      POSTGRES_USER: acp
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql

  agent-monitor:
    build: ./monitoring
    ports:
      - "8080:8080"
    environment:
      - MONITOR_INTERVAL=30
      - ALERT_WEBHOOK_URL=${ALERT_WEBHOOK_URL}

volumes:
  redis_data:
  postgres_data:
```

#### 🔌 エージェント統合例
```python
# エージェント実装例
class BaseAgent:
    def __init__(self, agent_id: str, agent_type: str):
        self.agent_id = agent_id
        self.agent_type = agent_type
        self.message_handler = MessageHandler(self)
        self.context_manager = ContextManager()
        self.acp_client = ACPClient(agent_id)
    
    async def start(self):
        """エージェント開始"""
        
        # ACP接続
        await self.acp_client.connect()
        
        # メッセージ処理開始
        await self.message_handler.start_listening()
        
        # コンテキスト初期化
        await self.context_manager.initialize()
        
        print(f"Agent {self.agent_id} started successfully")
    
    async def send_message(self, recipient_id: str, message_content: dict):
        """メッセージ送信"""
        
        message = {
            'header': {
                'protocol_version': '2.0',
                'message_id': f"msg-{uuid.uuid4()}",
                'timestamp': datetime.now().isoformat(),
                'ttl': 3600
            },
            'routing': {
                'sender': {
                    'agent_id': self.agent_id,
                    'agent_type': self.agent_type
                },
                'recipient': {
                    'agent_id': recipient_id
                }
            },
            'message': message_content
        }
        
        return await self.acp_client.send_message(message)
    
    async def handle_incoming_message(self, message: dict):
        """受信メッセージ処理"""
        
        message_type = message['message']['type']
        
        # メッセージタイプ別処理
        if message_type == 'task_assignment':
            await self._handle_task_assignment(message)
        elif message_type == 'progress_request':
            await self._handle_progress_request(message)
        elif message_type == 'code_review_request':
            await self._handle_code_review_request(message)
        else:
            await self._handle_unknown_message(message)
```

---

## 📋 運用・保守

### 定期メンテナンス

#### 🔄 システムヘルスチェック
```python
class SystemHealthChecker:
    def __init__(self):
        self.health_checks = [
            MessageQueueHealthCheck(),
            DatabaseHealthCheck(),
            AgentConnectivityCheck(),
            PerformanceCheck()
        ]
    
    async def run_health_check(self) -> dict:
        """システムヘルスチェック実行"""
        
        results = {}
        overall_status = "healthy"
        
        for check in self.health_checks:
            try:
                result = await check.run()
                results[check.name] = result
                
                if result['status'] != 'healthy':
                    overall_status = "degraded"
                    
            except Exception as e:
                results[check.name] = {
                    'status': 'error',
                    'error': str(e)
                }
                overall_status = "unhealthy"
        
        return {
            'overall_status': overall_status,
            'timestamp': datetime.now(),
            'individual_checks': results,
            'recommendations': self._generate_recommendations(results)
        }
```

---

*このエージェント間コミュニケーション仕様書は、システムの成長と運用経験に基づいて継続的に改善されます。* 