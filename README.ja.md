# Redmine Issue Wiki Journal

このプラグインは、Wiki ページの更新情報をチケットに関連付ける機能を提供します。

## 使い方

### 準備

まず、`管理 > 設定 > リポジトリ` から終了キーワードに対応するステータスを設定して下さい。
初期状態では、ステータスは設定されていません。このステータスが設定されていないと終了キーワードを使っても
ステータスの更新は行われません。

[<img src="http://hidakatsuya.github.io/redmine_issue_wiki_journal/images/setup.png" width="600">](http://hidakatsuya.github.io/redmine_issue_wiki_journal/images/setup.png)

### Wiki ページの更新をチケットに関連付ける

下図のように、ページを更新するときのコメントにキーワードと関連付けたいチケットNo を含めます。

[<img src="http://hidakatsuya.github.io/redmine_issue_wiki_journal/images/feature-1.png" width="600">](http://hidakatsuya.github.io/redmine_issue_wiki_journal/images/feature-1.png)

利用できるキーワードは `管理 > 設定 > リポジトリ` の設定内容によって決まりますが、
デフォルトでは ``refs``, ``references``, ``IssueID`` のようなキーワードが利用できます。

更新すると、下図のように関連先のチケットにコメントが記録されます。

[<img src="http://hidakatsuya.github.io/redmine_issue_wiki_journal/images/feature-2.png" width="600">](http://hidakatsuya.github.io/redmine_issue_wiki_journal/images/feature-2.png)

### Wiki ページの更新をチケットに関連付けステータスを終了状態に更新する

これも `管理 > 設定 > リポジトリ` の設定内容によって決まりますが、
デフォルトでは終了キーワードとして ``fixes``, ``closes`` のようなキーワードが利用できます。
使い方は関連付けるときと同様で、以下のようにコメントを記述します。

    インストール手順を修正 fixes #1234

これによって、関連先チケットにコメントが記録されると同時に終了状態へ更新されます。

## 動作環境

  * Redmine 2.3 以上
  * Ruby 1.9 以上

## インストール

以下のページをご覧下さい:  
http://www.redmine.org/projects/redmine/wiki/Plugins#Installing-a-plugin

## アンインストール

以下のページをご覧下さい:  
http://www.redmine.org/projects/redmine/wiki/Plugins#Uninstalling-a-plugin

## 貢献する

### Pull Request

  1. リポジトリをフォーク
  2. Feature ブランチを作る (``git checkout -b new-feature``)
  3. あなたの変更を commit (``git commit -am ``add some new feature``)
  4. ブランチを push (``git push origin new-feature``)
  5. Pull Request を作成

### プラグイン開発環境のセットアップ方法

TODO

### テストの実行方法

Redmine のルートディレクトリで以下のコマンドを実行:

    $ rake redmine:plugins:test NAME=redmine_issue_wiki_journal

### バグを報告する

[github issues](https://github.com/hidakatsuya/redmine_issue_wiki_journal/issues/new)

## Copyright

Copyright &copy; Katsuya Hidaka. See MIT-LICENSE for further details.

