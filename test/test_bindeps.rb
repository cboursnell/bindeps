require 'helper'

class TestBinDeps < Test::Unit::TestCase

  context "bindeps" do

    setup do
      test_dir = File.dirname(__FILE__)
      @data_dir = File.join(test_dir, 'data')
    end

    # teardown do
    #
    # end
    #
    # should "check if dependencies are installed" do
    #
    # end
    #
    # should "download and unpack dependencies" do
    # end

    should "identify and install missing dependencies" do
      test_yaml = File.join(@data_dir, 'fakebin.yaml')
      Bindeps.require test_yaml
      assert_equal 'success', `fakebin`.strip
    end

    should "handle case where version is not on first line" do
      test_yaml = File.join(@data_dir, 'fakebin2.yaml')
      # install fakebin2
      Bindeps.require test_yaml
      # now Dependency should detect it as installed
      deps = YAML.load_file test_yaml
      deps.each_pair do |name, config|
        d = Bindeps::Dependency.new(name,
                                    config['binaries'],
                                    config['version'],
                                    config['url'])
        assert d.installed?('fakebin2')
      end
    end

  end

end
