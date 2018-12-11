Aws.config[:rds] = {
  stub_responses: {
    describe_db_instances: {
      db_instances: [
        {
          db_instance_identifier: 'my-rds',
          db_instance_arn: 'arn:aws:rds:ap-northeast-1a:123456789012:db:my-rds',
          db_instance_status: 'available',
          db_instance_class: 'db.t2.medium',
          availability_zone: 'ap-northeast-1a',
          multi_az: false,
          endpoint: {
            address: 'my-rds-instance-endpoint'
          },
          engine: 'mysql'
        },
        {
          db_cluster_identifier: 'my-cluster',
          db_instance_identifier: 'my-cluster-instnace',
          db_instance_arn: 'arn:aws:rds:ap-northeast-1a:123456789012:db:my-cluster-instance',
          db_instance_status: 'available',
          db_instance_class: 'db.t2.medium',
          availability_zone: 'ap-northeast-1a',
          multi_az: false,
          endpoint: {
            address: 'my-cluster-endpoint'
          },
          engine: 'aurora'
        }
      ]
    },
    describe_db_clusters: {
      db_clusters: [
        {
          db_cluster_identifier: 'my-cluster',
          endpoint: 'my-cluster-endpoint',
          reader_endpoint: 'my-cluster-reader-endpoint',
          db_cluster_members: [
            {
              db_instance_identifier: 'my-cluster-writer-instance',
              is_cluster_writer: true
            },
            {
              db_instance_identifier: 'my-cluster-reader-instance',
              is_cluster_writer: false
            }
          ]
        }
      ]
    }
  }
}
