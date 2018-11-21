require 'spec_helper'
require "furikake/resources/security_group"

describe 'Furikake::Resources::SecurityGroup' do
  it 'check encode_value (simple pattern)' do
    expect = 'foo bar'
    actual = Furikake::Resources::SecurityGroup.encode_value('foo bar')
    expect(expect).to eq(actual)
  end

  it 'check encode_value (has `dash` pattern)' do
    expect = '\\-'
    actual = Furikake::Resources::SecurityGroup.encode_value('-')
    expect(expect).to eq(actual)
  end

  it 'check encode_value (has `under score` pattern)' do
    expect = '\\_'
    actual = Furikake::Resources::SecurityGroup.encode_value('_')
    expect(expect).to eq(actual)
  end
end
