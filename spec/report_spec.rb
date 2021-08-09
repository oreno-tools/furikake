require 'spec_helper'

describe 'Frikake::Report' do
  it 'check calls other than cli (defined params)' do
    param = { 'api_key' => 'xxxxx', 'foo' => 'bar' }
    report = Furikake::Report.new(nil, param)
    expect(param).to eq(report.instance_variable_get(:@params))
  end

  it 'check calls other than cli (undefined params)' do
    param = nil
    expect{ Furikake::Report.new(nil, param) }.to raise_error(ArgumentError, 'パラメータが設定されていません.')
  end

  it 'check check_api_key (api_key in param)' do
    param = { 'api_key' => 'xxxxx', 'foo' => 'bar' }
    report = Furikake::Report.new(true)
    actual = report.send(:check_api_key, param)
    expect(param).to eq(actual)
  end

  it 'check check_api_key (api_key not in param)' do
    param = { 'foo' => 'bar' }
    report = Furikake::Report.new(true)
    expect{ report.send(:check_api_key, param) }.to raise_error(RuntimeError, 'API キーを読み込むことが出来ませんでした.')
  end

  it 'check check_api_key (api_key not in param but have environment)' do
    ENV['BACKLOG_API_KEY'] = 'xxxxx'
    param = { 'foo' => 'bar' }
    expect = { 'api_key' => 'xxxxx', 'foo' => 'bar' }
    report = Furikake::Report.new(true)
    actual = report.send(:check_api_key, param)
    expect(param).to eq(actual)
  end
end