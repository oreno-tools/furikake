require 'spec_helper'

describe 'Frikake::Formatter' do
  it 'shaping markdwon with 1 resource' do
    contents = {
      title: 'xxxxxxxxxxxxxxxx',
      resources: [
          {
             subtitle: '',
             header: ['test1', 'test2'],
             resource: [['1', '2'], ['1', '2']]
          },
      ]
    }
    expect = <<"EOS"
### xxxxxxxxxxxxxxxx

|test1|test2|
|:-|:-|
|1|2|
|1|2|
EOS
    actual = Furikake::Formatter.shaping(nil, contents)
    expect(expect).to eq(actual)
  end

  it 'shaping markdwon with some resources' do
    contents = {
      title: 'xxxxxxxxxxxxxxxx',
      resources: [
          {
             subtitle: 'foo',
             header: ['test1', 'test2'],
             resource: [['1', '2'], ['1', '2']]
          },
          {
             subtitle: 'bar',
             header: ['test10', 'test20'],
             resource: [['1', '2'], ['1', '2']]
          },
      ]
    }
    expect = <<"EOS"
### xxxxxxxxxxxxxxxx

#### foo

|test1|test2|
|:-|:-|
|1|2|
|1|2|

#### bar

|test10|test20|
|:-|:-|
|1|2|
|1|2|
EOS
    actual = Furikake::Formatter.shaping(nil, contents)
    expect(expect).to eq(actual)
  end

  it 'shaping markdwon with empty resource' do
    contents = {
      title: 'xxxxxxxxxxxxxxxx',
      resources: [
          {
             subtitle: 'foo',
             header: ['test1', 'test2'],
             resource: []
          }
      ]
    }
    expect = <<"EOS"
### xxxxxxxxxxxxxxxx

#### foo

N/A
EOS
    actual = Furikake::Formatter.shaping(nil, contents)
    expect(expect).to eq(actual)
  end
end