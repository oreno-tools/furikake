require 'spec_helper'

describe 'furikake check version' do
  it 'has a version number' do
    expect(Furikake::VERSION).not_to be nil
  end

  it 'has a version number by cli' do
    output = capture(:stdout) { Furikake::CLI.start(%w{version}) }
    expect(output).to match(Furikake::VERSION)
  end
end

describe 'furikake check help' do
  it 'output `Commands:` by cli' do
    output = capture(:stdout) { Furikake::CLI.start(%w{help}) }
    expect(output).to match(/Commands:/)
  end

  it 'has a error message by cli' do
    output = capture(:stderr) { Furikake::CLI.start(%w{aaaa}) }
    expect(output).to match(/Could not find command "aaaa"./)
  end
end

# describe 'furikake check setup' do
#   it 'output Message by cli' do
#     output = capture(:stdout) { Furikake::CLI.start(%w{setup}) }
#     expect(output).to match(/[setup] .furikake.yml created./)
#   end
# end
