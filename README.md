# esa to markdown exporter
esaの記事をローカルmdテキストファイルに変換、ダウンロードするツール

## 準備
- [profile->application](https://playground.esa.io/user/applications) -> `Generate new token`
- `.env`にトークンとチームをセット

## 動作
### 実行
```
bundle exec ruby download_as_md_file.rb
```
### output
- `esaDir`配下
  - 記事をmdファイルにして保存
  - カテゴリをディレクトリとして保存
  - 本文mdの下に以下の情報を付与
    - 元記事のURL
    - 作成ユーザ名
    - タグ
    - コメント
      - 本文md
      - 投稿ユーザ名
- `archives/esa_posts.csv`
  - API取得した記事をそのままCSVとして保存している
  - 確認用
  - コメントは保存していない

## 備考
- 2021/07/17現在esaAPIは[15分75リクエスト制限](https://docs.esa.io/posts/102#%E5%88%A9%E7%94%A8%E5%88%B6%E9%99%90)あり
- コメントがある記事がたくさんあると引っかかる
