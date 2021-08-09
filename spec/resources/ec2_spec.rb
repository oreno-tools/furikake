require 'spec_helper'
require "furikake/resources/ec2"

describe 'Furikake::Resources::Ec2' do
  before :all do
    Furikake::Resources::Stub.load 'ec2'
  end

  it 'have markdown resource list' do
    expect = <<"EOS"
### EC2

|Name|Instance ID|Instance Type|Availability Zone|Private IP Address|Public IP Address|State|
|:-|:-|:-|:-|:-|:-|:-|
|my-ec2|i-ec12345a|t2.small|ap-northeast-1a|10.0.1.1|123.0.456.789|running|
EOS
    actual = Furikake::Resources::Ec2.report(nil)
    expect(expect).to eq(actual)
  end
end
