module Furikake
  module Resources
    module Alb
      def report
        albs, target_groups = get_resources
        headers = ['LB Name', 'DNS Name', 'Type', 'Target Group']
        if albs.empty?
          albs_info = 'N/A'
        else
          albs_info = MarkdownTables.make_table(headers,
                                                albs,
                                                is_rows: true,
                                                align: 'l')
        end
        
        headers = ['Target Group Name', 'Protocal', 'Port', 'Health Check Path', 'Health Chack Port', 'Health Check Protocol']
        if target_groups.empty?
          target_group_info = 'N/A'
        else
          target_group_info = MarkdownTables.make_table(headers,
                                                        target_groups,
                                                        is_rows: true,
                                                        align: 'l')
        end
        
        documents = <<"EOS"
### ELB (ALB / NLB)

#### ALB / NLB

#{albs_info}

#### Target Groups

#{target_group_info}
EOS
        documents
      end

      def get_resources
        alb = Aws::ElasticLoadBalancingV2::Client.new

        albs = []
        target_groups = []
        alb.describe_load_balancers.load_balancers.each do |lb|
          alb_info = []
          t = alb.describe_target_groups({
                                          load_balancer_arn: lb.load_balancer_arn
                                         }).target_groups.map(&:to_h)
          alb_info << lb.load_balancer_name
          alb_info << lb.dns_name
          alb_info << lb.type
          alb_info << (t.map {|a| a[:target_group_name]}).join(", ")
          albs << alb_info
          target_group = []
          target_group << (t.map {|a| a[:target_group_name]}).join(", ")
          target_group << (t.map {|a| a[:protocol]}).join(", ")
          target_group << (t.map {|a| a[:port]}).join(", ")
          target_group << (t.map {|a| a[:health_check_path].nil? ? " " : a[:health_check_path]}).join(", ")
          target_group << (t.map {|a| a[:health_check_port]}).join(", ")
          target_group << (t.map {|a| a[:health_check_protocol]}).join(", ")
          target_groups << target_group
        end

        return albs, target_groups
      end

      module_function :report, :get_resources
    end
  end
end
