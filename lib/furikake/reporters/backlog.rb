module Furikake
  module Reporters
    class Backlog
      def initialize(params)
        @client ||= BacklogKit::Client.new(
          space_id: params['space_id'],
          api_key: params['api_key'],
          top_level_domain: params['top_level_domain']
        )
        @wiki_id = params['wiki_id']
        @wiki_name = params['wiki_name']
        @wiki_contents = params['wiki_contents']
      end

      def publish
        params = {}
        params['name'] = @wiki_name
        params['content'] = @wiki_contents
        @client.update_wiki(@wiki_id, params)
      end
    end
  end
end