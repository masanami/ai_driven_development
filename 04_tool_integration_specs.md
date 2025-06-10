# ツール統合仕様書

## 🔧 ツール統合概要

CursorとModel Context Protocol (MCP) 統合により、AIアシスタントの能力を大幅に拡張します。
開発からプロジェクト管理まで、統一された環境で効率的なAI支援ワークフローを実現します。

---

## 🎯 対象ツール・環境

### **Cursor** 🖱️
- **主要用途**: コード開発、GitHub連携、データベース操作、情報管理、プロジェクト管理
- **MCP活用**: 開発から管理まで包括的なツール群
- **設定場所**: `~/.cursor/mcp-config.json`

### **補助ツール（オプション）**
- **Claude Desktop**: 必要に応じてCursorと同じMCP設定で補完的に利用可能
- **設定場所**: `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS)

---

## 🌐 Cursor統合MCP構成

### **包括的なMCP設定（推奨）**
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your_github_token"
      }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://localhost:5432/devdb"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/project"]
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    },
    "brave-search": {
      "command": "npx", 
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "your_brave_api_key"
      }
    },
    "google-drive": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-gdrive"],
      "env": {
        "GOOGLE_DRIVE_CREDENTIALS": "path/to/credentials.json"
      }
    },
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "your_slack_token"
      }
    }
  }
}
```

### **段階的導入（初心者向け）**
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your_github_token"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/project"]
    }
  }
}
```

---

## 🐙 GitHub統合

### **GitHub MCP Server設定**

#### 📋 基本設定
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_xxxxxxxxxxxxxxxxxxxx"
      }
    }
  }
}
```

#### 🔑 Personal Access Token 設定
1. GitHub Settings → Developer settings → Personal access tokens
2. 必要な権限:
   - `repo` (リポジトリアクセス)
   - `issues` (Issues読み書き)
   - `pull_requests` (PR操作)
   - `contents` (ファイル操作)

#### 🎯 利用例
```typescript
// Cursorでの利用イメージ
// 「このリポジトリの未解決Issuesを一覧表示して」
// 「新しいfeature branchを作成して」
// 「現在のコードの問題点を分析してIssueを作成して」
```

### **利用可能な操作**
- 📝 Issues の作成・更新・検索
- 🔄 Pull Request の作成・レビュー
- 🌳 ブランチ操作
- 📁 ファイル内容の取得・更新
- 👥 コラボレーター管理

---

## 💾 データベース統合

### **PostgreSQL MCP Server**

#### 📋 設定例
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": [
        "-y", 
        "@modelcontextprotocol/server-postgres",
        "postgresql://username:password@localhost:5432/database_name"
      ]
    }
  }
}
```

#### 🎯 利用例
```sql
-- Cursorでの利用イメージ
-- 「データベーススキーマを確認して」
-- 「パフォーマンスの悪いクエリを特定して」
-- 「テーブル設計の改善案を提案して」
```

### **SQLite MCP Server**
```json
{
  "mcpServers": {
    "sqlite": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sqlite", "/path/to/database.db"]
    }
  }
}
```

---

## 🧠 ナレッジベース・記憶統合

### **Memory MCP Server**

#### 📋 永続的記憶システム
```json
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    }
  }
}
```

#### 🎯 利用例
- 💭 プロジェクトの進捗状況を記憶
- 📚 学習した技術情報を蓄積
- 🔗 関連情報の関連付け管理
- 📝 コードレビューの履歴保存

### **Google Drive連携**
```json
{
  "mcpServers": {
    "gdrive": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-gdrive"],
      "env": {
        "GOOGLE_DRIVE_CREDENTIALS_FILE": "/path/to/credentials.json"
      }
    }
  }
}
```

---

## 🔍 検索・情報収集

### **Brave Search Integration**
```json
{
  "mcpServers": {
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "your_api_key_here"
      }
    }
  }
}
```

#### 🎯 利用例
```javascript
// Cursorでの利用イメージ
// 「React 18の新機能について最新情報を検索して」
// 「このエラーメッセージの解決方法を調べて」
// 「競合他社の技術スタックを分析して」
```

### **Web Scraping**
```json
{
  "mcpServers": {
    "puppeteer": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-puppeteer"]
    }
  }
}
```

---

## 💬 コミュニケーション統合

### **Slack連携**

#### 📋 設定例
```json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "xoxb-your-bot-token",
        "SLACK_USER_TOKEN": "xoxp-your-user-token"
      }
    }
  }
}
```

#### 🎯 利用例
```javascript
// Cursorでの利用イメージ
// 「#generalチャンネルの今日のメッセージを要約して」
// 「開発チームに進捗レポートを投稿して」
// 「重要な通知があったらコードコメントに含めて」
```

---

## 🛠️ 実装手順

### **Step 1: 環境準備**
```bash
# Node.js（最新LTS版）
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install --lts
nvm use --lts

# MCP サーバーの事前確認
npx @modelcontextprotocol/server-github --help
```

### **Step 2: Cursor設定**
```bash
# Cursor設定ディレクトリ作成
mkdir -p ~/.cursor

# 基本設定ファイル作成
cat > ~/.cursor/mcp-config.json << 'EOF'
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your_github_token_here"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/your/project"]
    }
  }
}
EOF
```

### **Step 3: 設定の拡張（オプション）**
```bash
# 包括的な設定に拡張
cat > ~/.cursor/mcp-config.json << 'EOF'
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your_github_token_here"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/your/project"]
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    },
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "your_brave_api_key"
      }
    }
  }
}
EOF
```

---

## 🔒 セキュリティ設定

### **環境変数管理**
```bash
# .envファイルでトークン管理
cat > .env << 'EOF'
GITHUB_PERSONAL_ACCESS_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx
BRAVE_API_KEY=your_brave_api_key
SLACK_BOT_TOKEN=xoxb-your-slack-bot-token
GOOGLE_DRIVE_CREDENTIALS_FILE=/path/to/credentials.json
EOF

# 権限設定
chmod 600 .env
```

### **アクセス制御**
- 🔐 最小権限の原則でトークンを発行
- 🔄 定期的なトークンローテーション
- 📊 アクセスログの監視

---

## 📊 モニタリング・ログ

### **MCP サーバー状態確認**
```bash
# サーバー起動確認
npx @modelcontextprotocol/inspector

# ログ確認（Cursor）
tail -f ~/.cursor/logs/mcp-*.log
```

### **パフォーマンス監視**
```javascript
// MCP応答時間監視例
const monitorMCPPerformance = () => {
  console.log('MCP Server Response Times:');
  // 各サーバーの応答時間を記録
};
```

---

## 🚀 統合ワークフロー例

### **包括的な開発フロー（Cursor中心）**
1. 🔍 **情報収集** → Brave Search MCPでリサーチ
2. 📋 **Issues確認** → GitHub MCP経由でIssue一覧取得
3. 🧠 **記憶参照** → Memory MCPで過去の学習内容確認
4. 🌳 **ブランチ作成** → GitHub MCPでブランチ操作
5. 💻 **コード開発** → ファイルシステムMCPで効率的な編集
6. 💾 **DB確認** → PostgreSQL MCPでスキーマ検証
7. 🔄 **PR作成** → GitHub MCPで自動PR生成
8. 💬 **チーム連携** → Slack MCPで進捗共有
9. 📚 **記憶保存** → Memory MCPで知見蓄積

### **プロジェクト管理フロー（Cursor中心）**
1. 📁 **ドキュメント確認** → Google Drive MCPで仕様書確認
2. 📊 **進捗分析** → GitHub MCPでIssue/PR統計取得
3. 🔍 **課題調査** → Brave Search MCPで技術情報収集
4. 💬 **チーム状況確認** → Slack MCPでチーム活動確認
5. 📝 **レポート作成** → 収集情報を統合してレポート生成
6. 🧠 **知見蓄積** → Memory MCPでプロジェクト情報保存

---

## 🔧 トラブルシューティング

### **よくある問題と解決策**

#### 🚫 接続エラー
```bash
# Node.jsバージョン確認
node --version  # v18以上推奨

# パッケージキャッシュクリア
npm cache clean --force

# MCP サーバー再起動
pkill -f "modelcontextprotocol"
```

#### 🔑 認証エラー
```bash
# トークン確認
echo $GITHUB_PERSONAL_ACCESS_TOKEN | cut -c1-10

# 権限確認（GitHub APIで）
curl -H "Authorization: token $GITHUB_PERSONAL_ACCESS_TOKEN" \
     https://api.github.com/user
```

#### 📱 Performance Issues
- 🕐 MCPサーバーのタイムアウト設定調整
- 💾 ローカルキャッシュの活用
- 🔄 接続プールの最適化

---

## 📚 参考資料

### **公式ドキュメント**
- [Model Context Protocol](https://modelcontextprotocol.io/)
- [MCP Servers Repository](https://github.com/modelcontextprotocol/servers)
- [Cursor Documentation](https://cursor.sh/docs)

### **コミュニティリソース**
- [MCP Discord Server](https://discord.gg/modelcontextprotocol)
- [GitHub Discussions](https://github.com/modelcontextprotocol/servers/discussions)

---

*この統合仕様書は、Cursor中心の実際の開発ワークフローに基づいて継続的に更新されます。* 