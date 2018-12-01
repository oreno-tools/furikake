require 'furikake/reporters/backlog'

module Furikake
  class Report
    include Furikake::Config

    def initialize(cli, params = nil)
      $stdout.sync = true
      @logger = Logger.new($stdout)
      @params = cli ? read_furikake_yaml : params
      raise ArgumentError, 'パラメータが設定されていません.' if @params.nil?
    end

    def show
      @params['backlog']['projects'].each do |p|
        header = insert_published_by(p['header'])
        footer = p['footer']
        puts generate(header, footer)
      end
    end

    def publish
      @params['backlog']['projects'].each do |p|
        header = insert_published_by(p['header'])
        footer = p['footer']
        document = generate(header, footer)
        p['wiki_contents'] = document
        param = check_api_key(p)
        Furikake::Reporters::Backlog.new(param).publish
        @logger.info("#{param['space_id']} の #{param['wiki_id']} に情報を投稿しました.")
      end
    end

    private

    def generate(header, footer)
      resource = Furikake::Resource.generate
      documents = <<"EOS"
#{header}
#{resource}
#{footer}
EOS
      documents
    end

    def check_api_key(param)
      if !param.has_key?('api_key') or param['api_key'].nil?
        if !ENV['BACKLOG_API_KEY'].nil? or !ENV['BACKLOG_API_KEY'] == ''
          param['api_key'] = ENV['BACKLOG_API_KEY'] 
          return param
        end
        raise 'API キーを読み込むことが出来ませんでした.'
      end
      param
    end

    def insert_published_by(header)
      headers = header.split("\n")
      headers.insert(1, published_by)
      headers.insert(2, "\n")
      headers.join("\n")
    end
 
    def published_by
      "*Published #{Time.now} by [furikake](https://github.com/inokappa/furikake)*"
    end
  end
end
