require 'rspec'
require 'furikake'
require 'furikake/resources/stub'

Aws.config.update(stub_responses: true)
ENV['AWS_PROFILE'] = 'dummy_profile'
ENV['AWS_REGION'] = 'us-east-1'

def capture(stream)
  begin
    stream = stream.to_s
    eval "$#{stream} = StringIO.new"
    yield
    result = eval("$#{stream}").string
  ensure
    eval("$#{stream} = #{stream.upcase}")
  end
  result
end
