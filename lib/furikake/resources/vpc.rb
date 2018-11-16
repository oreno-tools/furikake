module Furikake
  module Resources
    module Vpc
      def report
        resources = get_resources
        headers = ['Name', 'ID', 'CIDR', 'State']
        if resources.empty?
          info = 'N/A'
        else
          info = MarkdownTables.make_table(headers, resources, is_rows: true, align: 'l')
        end
        documents = <<"EOS"
### VPC

#{info}
EOS
        
        documents
      end

      def get_resources
        ec2 = Aws::EC2::Client.new
        vpcs = []
        ec2.describe_vpcs.vpcs.each do |v|
          vpc = []
          vpc << 'N/A' if v.tags.map(&:to_h).all? { |h| h[:key] != 'Name' }
          vpc << v.vpc_id
          vpc << v.cidr_block
          vpc << v.state
          vpcs << vpc
        end
        vpcs
      end

      module_function :report, :get_resources
    end
  end
end


