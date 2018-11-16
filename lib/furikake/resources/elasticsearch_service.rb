module Furikake
  module Resources
    module ElasticsearchService
      def report
        resources = get_resources
        headers = ['Domain Name', 'Endpoint', 'Instance Type', "Instance Count", "Elasticsearch Version", 'EBS Type', 'EBS Size']
        if resources.empty?
          info = 'N/A'
        else
          info = MarkdownTables.make_table(headers, resources, is_rows: true, align: 'l')
        end
        documents = <<"EOS"
### Elasticsearch Service

#{info}
EOS
        
        documents
      end

      def get_resources
        ess = Aws::ElasticsearchService::Client.new

        domains = []
        loop do
          res = ess.list_domain_names
          domains.push(*res.domain_names.map(&:to_h))
          break if res.domain_names.size == domains.size
        end

        domain_info = []
        domains.each do |domain|
          resource = []
          res = ess.describe_elasticsearch_domains({
                                                     domain_names: [domain[:domain_name]],
                                                   })
          res.domain_status_list.each do |r|
            resource << r[:domain_name]
            resource << r[:endpoints]['vpc']
            resource << r[:elasticsearch_cluster_config][:instance_type]
            resource << r[:elasticsearch_cluster_config][:instance_count]
            resource << r[:elasticsearch_version]
            resource << r[:ebs_options][:volume_type]
            resource << r[:ebs_options][:volume_size]
          end
          domain_info << resource
        end
        domain_info
      end

      module_function :report, :get_resources
    end
  end
end


