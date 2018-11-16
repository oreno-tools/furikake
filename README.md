# Furikake

![](https://raw.githubusercontent.com/inokappa/furikake/master/docs/images/furikake.png)

## これなに

* 利用している AWS リソースを Backlog の Wiki ページ (Markdown フォーマットのみ) に良しなに纏めてドキュメント化してくれるコマンドラインツールです
* 簡単なコードを追加することで, 取得する AWS リソースを増やすことが出来るようにはしています
* Backlog Wiki 以外にも登録出来るようにはしています

## Install

とりあえずは, `git clone` してきて `bundle install` する感じでお願い致します.

```sh
$ git clone git@github.com:inokappa/furikake.git
$ bundle install --path vendor/bundle
```

## Usage

### Create Wiki Page

* Backlog の wiki を作成し, wiki ID を控えておく (後の .furikake.yml で利用する)

### Write .envrc

とりあえずは, direnv と組み合わせて利用することを想定しており, AWS のクレデンシャル情報は .envrc に記載して下さい.

```sh
export AWS_PROFILE=your-profile
export AWS_REGION=ap-northeast-1
```

### Write .frikake.yml

カレントディレクトリに, 以下のような内容で .furikake.yml を作成して下さい.

```yaml
backlog:
  projects:
    - space_id: 'your-backlog-space-id'
      api_key: 'your-backlog-api-key'
      top_level_domain: 'your-backlog-top-level-domain'
      wiki_id: your-wiki-id
      wiki_name: 'your-wiki-name'
      header: >
        # Test Header
      footer: >
        # Test Footer
```

### Run

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
    module Clb
      def report
        resources = get_resources
        headers = ['LB Name', 'DNS Name', 'Instances']
        if resources.empty?
          info = 'N/A'
        else
          info = MarkdownTables.make_table(headers, resources, is_rows: true, align: 'l')
        end
        documents = <<"EOS"
### ELB (CLB)

#{info}
EOS
        
        documents
      end

      def get_resources
        elb = Aws::ElasticLoadBalancing::Client.new
        elbs = []
        elb.describe_load_balancers.load_balancer_descriptions.each do |lb|
          elb = []
          elb << lb.load_balancer_name
          elb << lb.dns_name
          elb << (lb.instances.map(&:to_h).map {|a| a[:instance_id] }).join(',')
          elbs << elb
        end
        elbs
      end

      module_function :report, :get_resources
    end
  end
end
```

report メソッドには, リソースのヘッダ名を `headers` に配列で指定します. get_resources メソッドにドキュメント化したいリソースの一覧を取得する為の処理を追加します. 戻り値は, 以下のようなフォーマットになるように実装して下さい.

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
