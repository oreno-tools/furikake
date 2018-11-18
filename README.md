# Furikake [![Build Status](https://travis-ci.org/inokappa/furikake.svg?branch=master)](https://travis-ci.org/inokappa/furikake) [![Gem Version](https://badge.fury.io/rb/furikake.svg)](https://badge.fury.io/rb/furikake)
![](https://raw.githubusercontent.com/inokappa/furikake/master/docs/images/furikake.png)

## これなに

* 利用している AWS リソースを Backlog の Wiki ページ (Markdown フォーマットのみ) に良しなに纏めてドキュメント化してくれるコマンドラインツールです
* 簡単なコードを追加することで, 取得する AWS リソースを増やすことが出来るようにはしています
* Backlog Wiki 以外にも登録出来るようにはしています

## Install

Add this line to your application's Gemfile:

```ruby
gem 'furikake'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install furikake
```

## Getting Started

### Step 1: Create Wiki Page

* Backlog の wiki を作成し, wiki ID を控えておく (後の .furikake.yml で利用する)

### Step 2: Write .envrc

とりあえずは, direnv と組み合わせて利用することを想定しており, AWS のクレデンシャル情報は .envrc に記載して下さい.

```sh
export AWS_PROFILE=your-profile
export AWS_REGION=ap-northeast-1
```

### Step 3: Generate && Modify .frikake.yml

If you're starting on a fresh furikake project, you can use furikake to generate your .furikake.yml:

```sh
bundle exec furikake setup
```

以下のように .furikake.yml が生成されるので, 環境に応じて必要な箇所を修正して下さい.

```yaml
resources:
  aws:
    - clb
    - vpc_endpoint
    - security_group
    - ec2
    - kinesis
    - lambda
    - alb
    - directory_service
    - elasticsearch_service
    - vpc
    - rds
backlog:
  projects:
    - space_id: 'your-backlog-space-id'
      api_key: 'your-backlog-api-key'
      top_level_domain: 'your-backlog-top-level-domain'
      wiki_id: your-wiki-id
      wiki_name: 'your-wiki-name'
      header: >
        # Test Header

        [toc]

        ## Sub Header
      footer: >
        ## Test Footer

        ### Sub Footer
```

`resources` キー以下の属性値については, ドキュメント化する対象のリソースとなります.

### Step 4: Run

```sh
# ドキュメント化する情報を標準出力に出力する
bundle exec furikake show

# ドキュメント化する情報を wiki に登録する
bundle exec furikake publish
```

## Tips

### リソース追加

`lib/furikake/resources/` 以下に任意のファイル名でコードを追加することで, ドキュメント化する対象のリソースを追加することが出来ます.

```ruby
module Furikake
  module Resources
    module Ec2
      def report(format = nil)
        instance = get_resources
        contents = {
          title: 'EC2',
          resources: [
            {
               subtitle: '',
               header: ['Name', 'Instance ID', 'Instance Type',
                        'Availability Zone', 'Private IP Address',
                        'Public IP Address', 'State'],
               resource: instance
            }
          ]
        }
        Furikake::Formatter.shaping(format, contents)
      end

      def get_resources
        ec2 = Aws::EC2::Client.new
        params = {}
        instances = []
        loop do
          res = ec2.describe_instances(params)
...
```

report メソッドには, 一覧化する際のヘッダを `header` に配列で指定します.

尚, get_resources メソッドにドキュメント化したいリソースの一覧を取得する為の処理を追加します. 戻り値は, 以下のようなフォーマットになるように実装して下さい.

```
[['ID', 'Name', 'Status'], ['ID', 'Name', 'Status'], ['ID', 'Name', 'Status']]
```

## Todo

* エラー処理
* デーモン化
* Backlog Wiki 以外の Wiki (例えば, Github Wiki や Gist 等)
* テスト追加

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/furikake.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
