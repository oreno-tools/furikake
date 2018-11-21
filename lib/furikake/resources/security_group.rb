module Furikake
  module Resources
    module SecurityGroup
      def report
        ingresses, egresses = get_resources
        headers = ['ID', 'Group Name', 'Description',
                   'Port', 'Protocol', 'Source' ]
        ingress_info = MarkdownTables.make_table(headers, ingresses, is_rows: true, align: 'l')

        headers = ['ID', 'Group Name', 'Description',
                   'Port', 'Protocol', 'Destination' ]
        egress_info = MarkdownTables.make_table(headers, egresses, is_rows: true, align: 'l')

        documents = <<"EOS"
### Security Group

#### Ingress

#{ingress_info}

#### Egress

#{egress_info}
EOS

        documents
      end

      def get_resources
        ec2 = Aws::EC2::Client.new
        params = {}
        ingresses = []
        egresses = []
        loop do
          res = ec2.describe_security_groups(params)
          res.security_groups.each do |sg|
            sg.ip_permissions.each do |permission|
              ingress = []
              ingress << sg.group_id
              ingress << encode_value(sg.group_name)
              ingress << encode_value(sg.description || 'N/A')
              ingress << (permission.from_port || 'N/A')
              ingress << (permission.ip_protocol == '-1' ? 'ALL' : permission.ip_protocol)
 
              ip_ranges = list_ip_ranges(permission.ip_ranges)
              list_ids = list_ids(permission.prefix_list_ids)
              group_pairs = list_group_pairs(permission.user_id_group_pairs)

              source = []
              source << ip_ranges unless ip_ranges.empty?
              source << list_ids unless list_ids.empty?
              source << group_pairs unless group_pairs.empty?
              ingress << source.join(', ')
              ingresses << ingress
            end
 
            sg.ip_permissions_egress.each do |permission|
              egress = []
              egress << sg.group_id
              egress << encode_value(sg.group_name)
              egress << encode_value(sg.description || 'N/A')
              egress << (permission.from_port || 'N/A')
              egress << (permission.ip_protocol == '-1' ? 'ALL' : permission.ip_protocol)

              ip_ranges = list_ip_ranges(permission.ip_ranges)
              list_ids = list_ids(permission.prefix_list_ids)
              group_pairs = list_group_pairs(permission.user_id_group_pairs)

              dest = []
              dest << ip_ranges unless ip_ranges.empty?
              dest << list_ids unless list_ids.empty?
              dest << group_pairs unless group_pairs.empty?
              egress << dest.join(', ')
              egresses << egress
            end
          end
          break if res.next_token.nil?
          params[:next_token] = res.next_token
        end

        return ingresses, egresses
      end

      def list_ip_ranges(ip_ranges)
        result = []
        ip_ranges.each do |ip|
          result << (ip.cidr_ip || 'N/A') + ' (' + (ip.description || 'N/A') + ')'
        end
        result
      end
      
      def list_ids(prefix_list_ids)
        result = []
        prefix_list_ids.each do |id|
          result << (id.prefix_list_id || 'N/A') + ' (' + (id.description|| 'N/A') + ')'
        end
        result
      end
      
      def list_group_pairs(user_id_group_pairs)
        result = []
        user_id_group_pairs.each do |id|
          result << (id.group_id || 'N/A') + ' (' + (id.description|| 'N/A') + ')'
        end
        result
      end

      def encode_value(value)
        return ('\\' + value) if value == '-'
        return ('\\' + value) if value.index('_') == 0
        value
      end

      module_function :report, :get_resources,
                      :list_ip_ranges, :list_ids, :list_group_pairs,
                      :encode_value
    end
  end
end
