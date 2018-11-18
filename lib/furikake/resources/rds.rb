module Furikake
  module Resources
    module Rds
      def report(format = nil)
        instance, cluster = get_resources
        contents = {
          title: 'RDS',
          resources: [
              {
                 subtitle: 'DB Instances',
                 header: ['DB Cluster Name', 'DB Instance Name',
                          'DB Instance Class', 'DB Engine', 'DB Endpoint'],
                 resource: instance
              },
              {
                 subtitle: 'DB Clusters',
                 header: ['DB Cluster Name', 'Cluster Endpoint',
                          'Cluster Reader Endpoint', 'Cluster Members'],
                 resource: cluster
              }
          ]
        }
        Furikake::Formatter.shaping(format, contents).chomp
      end

      def get_resources
        rds = Aws::RDS::Client.new

        rds_infos = []
        rds.describe_db_instances.db_instances.map(&:to_h).each do |i|
          instance = []
          instance << i[:db_cluster_identifier]
          instance << i[:db_instance_identifier]
          instance << i[:db_instance_class]
          instance << i[:engine]
          instance << i[:endpoint][:address]
          rds_infos << instance
        end

        cluster_infos = []
        rds.describe_db_clusters.db_clusters.map(&:to_h).each do |c|
          cluster = []
          cluster << c[:db_cluster_identifier]
          cluster << c[:endpoint]
          cluster << c[:reader_endpoint]
          cluster << (c[:db_cluster_members].map {|m| m[:is_cluster_writer] ? m[:db_instance_identifier] + '(W)' : m[:db_instance_identifier] + '(R)'}).join(', ')
          cluster_infos << cluster
        end

        return rds_infos, cluster_infos
      end

      module_function :report, :get_resources
    end
  end
end
