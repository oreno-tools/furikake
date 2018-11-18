module Furikake
  module Resources
    module Ec2
      def report(format = nil)
        instance = get_resources
        contents = {
          title: 'EC2',
          resources: [
            {
               subtitle: '',
               header: ['Name', 'Instance ID', 'Instance Type',
                        'Availability Zone', 'Private IP Address',
                        'Public IP Address', 'State'],
               resource: instance
            }
          ]
        }
        Furikake::Formatter.shaping(format, contents)
      end

      def get_resources
        ec2 = Aws::EC2::Client.new
        params = {}
        instances = []
        loop do
          res = ec2.describe_instances(params)
          res.reservations.each do |r|
            r.instances.each do |i|
              instance = []
              instance << 'N/A' if i.tags.map(&:to_h).all? { |h| h[:key] != 'Name' }
              i.tags.each do |tag|
                instance << tag.value if tag.key == 'Name'
              end
              instance << i.instance_id
              instance << i.instance_type
              instance << i.placement.availability_zone
              instance << i.private_ip_address
              if i.public_ip_address.nil?
                instance << ' '
              else
                instance << i.public_ip_address
              end
              instance << i.state.name
              instances << instance
            end
          end
          break if res.next_token.nil?
          params[:next_token] = res.next_token
        end

        instances
      end
      module_function :report, :get_resources
    end
  end
end
