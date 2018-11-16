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
