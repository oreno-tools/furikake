module Furikake
  module Resources
    module Lambda
      def report
        resources = get_resources
        headers = ['Function Name', 'Function ARN', 'Runtime', 'Timeout', 'Memory Size']
        if resources.empty?
          info = 'N/A'
        else
          info = MarkdownTables.make_table(headers, resources, is_rows: true, align: 'l')
        end
        documents = <<"EOS"
### Lambda Functions

#{info}
EOS
        
        documents
      end

      def get_resources
        lmb = Aws::Lambda::Client.new

        req = {}
        functions = []
        loop do
          res = lmb.list_functions(req)
          functions.push(*res.functions)
          break if res.next_marker.nil?
          req[:marker] = res.next_marker
        end

        function_infos = []
        functions.map(&:to_h).each do |f|
          function = []
          function << f[:function_name]
          function << f[:function_arn]
          function << f[:runtime]
          function << f[:timeout]
          function << f[:memory_size]
          function_infos << function
        end
        function_infos
      end

      module_function :report, :get_resources
    end
  end
end
