# 概要
Sinatraで作成したメモアプリ。<br/>
Ver.1: データがファイルに保存されている状態。
Ver.2: データがDBに保存されている状態。

# 機能
- メモの新規作成
- 既存メモの編集
- 既存メモの削除
- メモの一覧表示

# 手順
1. `git clone`を実行してローカルに複製
```
% git clone https://github.com/hiromisugie/my_sinatra
```

2. `my_sinatra`ディレクトリへ移動
```
% cd my_sinatra
```

3. `bundle install`を実行し、必要なGemをインストール
```
% bundle install
```

4. PostgreSQLを起動
```
% brew services start postgresql
```

5. postgresに接続
```
% psql postgres
```

6. データベースを作成
```
% create database mydb;
```

7. postgresから抜ける
```
% \q 
```

8. 作成したデータベース`mydb`に接続する
```
% psql mydb
```

9. テーブルを作成
```
% create table memos(id CHAR(36), title text, body text); 
```

10. mydbから抜ける
```
% \q 
```

11. PostgreSQLを停止
```
% brew services stop postgresql
```

12. `app.rb`を実行
```
% bundle exec ruby app.rb
```

13. ブラウザで`http://localhost:4567`にアクセスして表示を確認