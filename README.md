# hubot-starbucks-egift

## 概要
* Webhookから[Starbucks eGift](https://gift.starbucks.co.jp/)を発行するHubotです。
* 詳しい環境構築方法は[Qiita](http://qiita.com/cgetc/items/692d0eb657c74a02a917)にまとめました。

## 注意事項
* 勝手に決済されるため、インストールするサーバのアクセス制限は適切に行ってください。
* 使用するクレジットカードはバーチャルカードの利用をお勧めします。

## 使い方

### インストール方法

#### package.jsonに追加
```
"dependencies": {
  "hubot-starbucks-egift": "0.0.1"
}
```

#### external-scripts.jsonに追加
```
["hubot-starbucks-egift"]
```

#### リソースファイルの配備
```
export HUBOT_HOME="Hubotのルートディレクトリ"
cp -P hubot-starbucks-egift/resources.sample $HUBOT_HOME/resources
cp -P hubot-starbucks-egift/judge.sample $HUBOT_HOME/judge
```

#### Seleniumをインストール
* [Dockerfile](https://github.com/SeleniumHQ/docker-selenium)が公開されているので、Docker内に構築するのが手っ取り早いです
* 詳細は割愛します

#### 環境変数を設定
<dl>
  <dt>SELENIUM_BROWSER</dt>
  <dd>chrome</dd>
  <dt>SELENIUM_REMOTE_URL</dt>
  <dd>SeleniumのサーバURL</dd>
  <dt>STARBUCKS_MAIL_ADDRESS</dt>
  <dd>決済通知先のメールアドレス</dd>
  <dt>STARBUCKS_CREDIT_NUMBER</dt>
  <dd>クレジットカード番号</dd>
  <dt>STARBUCKS_CREDIT_MONTH</dt>
  <dd>クレジットカード（月）</dd>
  <dt>STARBUCKS_CREDIT_YEAR</dt>
  <dd>クレジットカード（年）</dd>
</dl>

### Webhookの指定

```
http://<ホスト>/<judge内のファイル>
```

## カスタマイズ

### メッセージの変更
* resources/message.json内のメッセージを変更してください。

### 発行条件の変更
* judgeディレクトリ内に以下のようなスクリプトを追加してください
* ファイル名はURLの一部になります
```
module.exports -> (robot, req)->
    if not_send
        send: false, message: "エラーメッセージ"

    send: true
    options:
        room: "送信するroom"
    message: "ギフトカード及びチャットのメッセージ"
```
