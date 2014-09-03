require_relative '../spec_helper'

def create(key, val, opts={})
  chef_run = opts[:chef_run] || ChefSpec::Runner.new(step_into: ['rcconf'])
  path = opts[:path] || '/etc/rc.conf'
  it "sets #{key} to #{val} in #{path}" do
    chef_run.converge_virtual_recipe('rcconf-cookbook::default') do
      rcconf "sets #{key} to #{val} in #{path}" do
        path opts[:path] if opts[:path]
        key key
        value val
      end
    end
    expect(chef_run).to rcconf_create("sets #{key} to #{val} in #{path}")
    re = /^#{Regexp.escape(key)}=#{Regexp.escape(val.to_s.inspect)}$/
    expect(chef_run).to render_file(path).with_content(re)
  end
  chef_run
end

def create_if_missing(key, val, opts={})
  chef_run = opts[:chef_run] || ChefSpec::Runner.new(step_into: ['rcconf'])
  path = opts[:path] || '/etc/rc.conf'
  it "sets (if missing) #{key} to #{val} in #{path}" do
    chef_run.converge_virtual_recipe('rcconf-cookbook::default') do
      rcconf "sets (if missing) #{key} to #{val} in #{path}" do
        path opts[:path] if opts[:path]
        key key
        value val
        action :create_if_missing
      end
    end
    expect(chef_run).to rcconf_create_if_missing("sets (if missing) #{key} to #{val} in #{path}")
    re = /^#{Regexp.escape(key)}=.*$/
    expect(chef_run).to render_file(path).with_content(re)
  end
  chef_run
end

def remove(key, opts={})
  chef_run = opts[:chef_run] || ChefSpec::Runner.new(step_into: ['rcconf'])
  path = opts[:path] || '/etc/rc.conf'
  it "removes #{key} from #{path}" do
    chef_run.converge_virtual_recipe('rcconf-cookbook::default') do
      rcconf "remove #{key} from #{path}" do
        path opts[:path] if opts[:path]
        key key
        action :remove
      end
    end
    expect(chef_run).to rcconf_remove("remove #{key} from #{path}")
    re = /^#{Regexp.escape(key)}=.*$/
    expect(chef_run).to_not render_file(path).with_content(re)
  end
  chef_run
end

def common_tests(opts={})
  create('foo', 'bar', opts)
  create('foo', 42, opts)
  create('baz', true, opts)
  create('test_name', false, opts)
  create_if_missing('bar', nil, opts)
  create_if_missing('bar', 'none', opts)
  remove('foo', opts)
  remove('bar', opts)
  remove('test_name', opts)
end

describe 'rcconf::default' do
  let(:data) { '' }
  before do
    allow(IO).to receive(:read).and_call_original
    allow(IO).to receive(:read).with('/etc/rc.conf').and_return(data)
    allow(IO).to receive(:read).with('/etc/rc-foo.conf').and_return(data)
  end

  context 'when the file is empty' do
    let(:lines) { '' }
    common_tests
  end

  context 'when the file has foo= set' do
    let(:lines) { "foo=\"bar\"\n" }
    common_tests
  end

  context 'when the file has multiple values set' do
    let(:lines) {
      [
        'foo="YES"',
        'bar="NO"',
        '# some comment'
      ].join("\n") + "\n"
    }
    common_tests
  end

  context 'when the file has garbage in it' do
    let(:lines) {
      [
        'YOLO',
        '#swag',
        'whatever',
        'skatebordd'
      ].join("\n") + "\n"
    }
    common_tests
  end

  context 'when a custom file is used' do
    let(:lines) { "foo=\"bar\"\n" }
    common_tests({:path => '/etc/rc-foo.conf'})
  end

  context 'when a non-existent file is used' do
    chef_run = ChefSpec::Runner.new(step_into: ['rcconf'])
    it 'should throw an error' do
      path = '/this/file/should/not/exist'
      key = 'foo'
      val = 'bar'
      expect {
        chef_run.converge_virtual_recipe('rcconf') do
          rcconf "set #{key} to #{val}" do
            path path
            key key
            value val
          end
        end
      }.to raise_error
    end
  end
end
