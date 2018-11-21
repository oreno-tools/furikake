require 'spec_helper'

describe 'Frikake::Report' do
  before(:each) { @report = Furikake::Report.new }

  it 'check check_api_key (api_key in param)' do
    param = { 'api_key': 'xxxxx', 'foo': 'bar' }
    actual = @report.send(:check_api_key, param)
    expect(param).to eq(actual)
  end

  it 'check check_api_key (api_key not in param)' do
    param = { 'foo': 'bar' }
    expect{@report.send(:check_api_key, param)}.to raise_error(RuntimeError, 'API キーを読み込むことが出来ませんでした.')
  end

  it 'check check_api_key (api_key not in param but have environment)' do
    ENV['BACKLOG_API_KEY'] = 'xxxxx'
    param = { 'foo': 'bar' }
    expect = { 'api_key': 'xxxxx', 'foo': 'bar' }
    actual = @report.send(:check_api_key, param)
    expect(param).to eq(actual)
  end
end
