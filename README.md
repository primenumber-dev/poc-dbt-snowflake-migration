# dbt + Snowflake プロジェクト

- [セットアップ手順](#セットアップ手順)
- [環境構築](#環境構築)
- [環境変数設定](#環境変数設定)
- [dbt設定](#dbt設定)
- [基本コマンド](#基本コマンド)

## セットアップ手順

1. **ツールのインストール**：
```bash
# aquaのインストール
curl -sSfL -O https://raw.githubusercontent.com/aquaproj/aqua-installer/v3.1.1/aqua-installer
chmod +x aqua-installer
./aqua-installer

# パッケージのインストール
aqua i
uv sync --frozen
```

2. **設定ファイルの準備**：
```bash
# 環境変数設定
cp example.env .env
# .envファイルを編集して実際の値を設定

# dbt profiles設定
cp example-profiles.yml ~/.dbt/profiles.yml
```

3. **環境変数の自動読み込み設定**（`~/.bashrc`に追加）：
```bash
export PATH="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH"
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi
```

4. **接続確認**：
```bash
dbt debug
```

### 設定項目
- `example.env`を`.env`にコピーして実際の値を設定
- Snowflake接続情報（アカウント、ユーザー、ロールなど）
- ファイルパス（プロジェクトや秘密鍵の場所）
## dbt設定

### Snowflake認証設定
RSA鍵ペアを生成（初回のみ）：
```bash
openssl genrsa 4096 | openssl pkcs8 -topk8 -inform PEM -v2 aes-256-cbc -out .snowflake/rsa_key.p8 -nocrypt
openssl rsa -in .snowflake/rsa_key.p8 -pubout -out .snowflake/rsa_key.pub
```

Snowflakeに公開鍵を登録：
```sql
ALTER USER your_username SET RSA_PUBLIC_KEY='your_public_key_content';
```

## 基本コマンド

- `dbt debug`: 接続確認
- `dbt deps`: 依存パッケージのインストール
- `dbt seed`: CSVファイルのロード
- `dbt run`: モデルの実行
- `dbt test`: データ品質テストの実行
- `dbt docs generate`: ドキュメント生成
- `dbt docs serve`: ドキュメント表示
