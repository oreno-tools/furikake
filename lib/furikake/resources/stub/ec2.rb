Aws.config[:ec2] = {
  stub_responses: {
    describe_instances: {
      reservations: [
        {
          instances: [
            {
              instance_id: 'i-ec12345a',
              image_id: 'ami-abc12def',
              vpc_id: 'vpc-ab123cde',
              subnet_id: 'subnet-1234a567',
              public_ip_address: '123.0.456.789',
              private_ip_address: '10.0.1.1',
              instance_type: 't2.small',
              state: {
                name: 'running'
              },
              tags: [
                {
                  key: 'Name',
                  value: 'my-ec2'
                }
              ],
              placement: {
                availability_zone: 'ap-northeast-1a'
              }
            }
          ]
        }
      ]
    }
  }
}
