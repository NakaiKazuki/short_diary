# Short Diary
 50文字以内の日記を投稿するサイトです。<br >
 一言二言の内容で日記を書くことで継続しやすくしています。 <br >
 スマホからもご利用いただけます。

# URL
https://short-diary.com/ <br >
画面中央やや左の「ゲストとしてログイン」のボタンから、メールアドレスとパスワードを入力せずにログインできます。
ゲストユーザーは登録情報の編集と削除のみを制限しています。

# 使用技術
- Ruby 2.7.2
- Ruby on Rails 6.0.3.5
- MySQL 8.0
- Nginx
- Puma
- AWS
  - VPC
  - EC2
  - RDS(MySQL)
  - Route53
  - S3
  - Certificate Manager
- Docker/Docker-compose
- CircleCi CI/CD
- Capistrano3
- RSpec
- reCAPTCHA
- Google Analytics

# CircleCi CI/CD
- Githubへのpush時に、ワークフローとして Rubocop Brakeman RSpecの順で各フローが成功した場合に実行されます。
- masterブランチへのpushでは、Rubocop Brakeman RSpecが全て成功した場合に限り、Capistranoを使用してEC2への自動デプロイが実行されます。
  自動デプロイ時にはCircleCiが使用しているIPアドレスからEC2へのSSH接続を許可し、デプロイが成功or失敗した場合後に使用したIPアドレスの接続許可を削除します。

# 機能一覧
- ユーザー登録、ログイン機能(devise)
  - ロボット確認(recaptcha)
- 投稿機能
  - 画像投稿(ActiveStorage)
    - 本番環境ではS3に保存
- お気に入り機能(Ajax)
- 日記投稿機能
  - 削除機能のみAjax
- ページネーション機能(pagy)
- 検索機能(ransack)
- DoS攻撃対策(rack-attack)
  - 60回/1分 の接続でIP制限
- サイト分析(google-analytics-rails)

# テスト
- RSpec
  - モデルテスト(model)
  - コントローラーテスト(request)
  - ブラウザテスト(system)

# ローカルで使用する場合
リポジトリを手元にクローンしてください。

```
$ git clone https://github.com/NakaiKazuki/short_diary.git
```

次にクローンしたリポジトリのディレクトリへ移動します。
```
$ cd short_diary
```

その後下記のコマンドでdockerimageを作成します。

```
$ docker-compose build
```

dockerimage作成後コンテナを起動します。

```
$ docker-compose up -d
```

コンテナ起動後に下記のコマンドでアプリのコンテナへ入ります。

```
$ docker-compose exec webapp bash
```

コンテナに入れたらデータベースへseedデータを作成します。

```
$ rails db:create db:migrate db:seed
```

その後test環境のデータベースへのマイグレーションを実行します。

```
$ rails db:migrate RAILS_ENV=test
```

Rubocop Brakeman RSpecを実行する場合は、以下のシェルスクリプトでまとめて実行できます。

```
$ sh check.sh
```

# 制作者

* 中井一樹
* Twitter : https://twitter.com/k_kyube

# ライセンス

Output Readingは[MITライセンス](https://en.wikipedia.org/wiki/MIT_License)のもとで公開されています。詳細は [LICENSE.md](https://github.com/NakaiKazuki/short_diary/blob/master/LICENSE.md) をご覧ください。