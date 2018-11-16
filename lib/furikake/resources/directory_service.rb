module Furikake
  module Resources
    module DirectoryService
      def report
        resources = get_resources
        headers = ['Directory ID', 'DNS Name', 'NetBIOS Name', 'Type', 'DNS Addresses', 'Size']
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
        ds = Aws::DirectoryService::Client.new

        req = {}
        resouces = []
        loop do
          res = ds.describe_directories(req)
          resouces.push(*res.directory_descriptions.map(&:to_h))
          break if res.next_token.nil?
          req[:next_token] = res.next_token
        end
      
        directoryservice_infos = []
        resouces.each do |r|
          directory = []
          directory << r[:directory_id]
          directory << r[:name]
          directory << r[:short_name]
          directory << r[:type]
          directory << r[:dns_ip_addrs].join(', ')
          directory << r[:size]
          directoryservice_infos << directory
        end
        directoryservice_infos
      end

      module_function :report, :get_resources
    end
  end
end
