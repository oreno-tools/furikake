require 'spec_helper'
require "furikake/resources/rds"

describe 'Furikake::Resources::Rds' do
  before :all do
    Furikake::Resources::Stub.load 'rds'
  end

  it 'have markdown resource list' do
    expect = <<"EOS"
### RDS

#### DB Instances

DB Cluster Name|DB Instance Name|DB Instance Class|DB Engine|DB Endpoint
:-|:-|:-|:-|:-
N/A|my-rds|db.t2.medium|mysql|my-rds-instance-endpoint
my-cluster|my-cluster-instnace|db.t2.medium|aurora|my-cluster-endpoint

#### DB Clusters

DB Cluster Name|Cluster Endpoint|Cluster Reader Endpoint|Cluster Members
:-|:-|:-|:-
my-cluster|my-cluster-endpoint|my-cluster-reader-endpoint|my-cluster-writer-instance(W), my-cluster-reader-instance(R)
EOS
    actual = Furikake::Resources::Rds.report(nil)
    expect(expect.chomp).to eq(actual.chomp)
  end
end
