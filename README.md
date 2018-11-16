# Furikake

## これなに

* 利用している AWS リソースを Backlog の Wiki ページ (Markdown フォーマットのみ) に良しなに纏めて登録してくれるコマンドラインツールです
* 簡単なコードを追加することで, 取得する AWS リソースを増やすことが出来るようにはしています
* Backlog Wiki 以外にも登録出来るようにはしています

## Install

とりあえずは, `git clone` してきて `bundle install` する感じで.

```sh
```

## Usage

### Create Wiki Page

* Backlog の wiki を作成し, wiki ID を控えておく (後の .furikake.yml で利用する)

### Write .envrc

とりあえずは, direnv と組み合わせて利用することを想定している. AWS のクレデンシャル情報は .envrc に記載する.

```sh
export AWS_PROFILE=your-profile
export AWS_REGION=ap-northeast-1
```

### Write .frikake.yml

カレントディレクトリに, 以下のような内容で .furikake.yml を作成する.

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
# 
bundle exec furikake show
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/furikake.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
