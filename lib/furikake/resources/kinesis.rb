module Furikake
  module Resources
    module Kinesis
      def report
        resources = get_resources
        headers = ['Stream Name', 'Stream ARN', 'Stream Status', 'Shards']
        if resources.empty?
          info = 'N/A'
        else
          info = MarkdownTables.make_table(headers, resources, is_rows: true, align: 'l')
        end
        documents = <<"EOS"
### Kinesis

#{info}
EOS
        
        documents
      end

      def get_resources
        kinesis = Aws::Kinesis::Client.new

        all_streams = []
        loop do
          res = kinesis.list_streams
          all_streams.push(*res.stream_names)
          break unless res.has_more_streams
        end

        kinesis_infos = []
        all_streams.each do |stream|
          keys = [:stream_name, :stream_arn, :stream_status]
          res = kinesis.describe_stream({
                                          stream_name: stream
                                        })
          resouces = []
          res.stream_description.to_h.each do |k, v|
            if keys.include?(k)
              resouces << v
            end
            if k == :shards
              resouces << v.size
            end
          end
          kinesis_infos << resouces
        end
        kinesis_infos
      end

      module_function :report, :get_resources
    end
  end
end
