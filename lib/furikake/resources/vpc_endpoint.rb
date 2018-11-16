module Furikake
  module Resources
    module VpcEndpoint
      def report
        resources = get_resources
        headers = ['ID', 'Type', 'VPC ID', 'State']
        if resources.empty?
          info = 'N/A'
        else
          info = MarkdownTables.make_table(headers, resources, is_rows: true, align: 'l')
        end
        documents = <<"EOS"
### VPC Endpoint

#{info}
EOS
        
        documents
      end

      def get_resources
        ec2 = Aws::EC2::Client.new
        params = {}
        endpoints = []
        loop do
          res = ec2.describe_vpc_endpoints(params)
          res.vpc_endpoints.each do |e|
            endpoint = []
            endpoint << e.vpc_endpoint_id
            endpoint << e.vpc_endpoint_type
            endpoint << e.vpc_id
            endpoint << e.state
            endpoints << endpoint
          end
          break if res.next_token.nil?
          params[:next_token] = res.next_token
        end

        endpoints
      end

      module_function :report, :get_resources
    end
  end
end
