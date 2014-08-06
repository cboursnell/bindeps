require 'helper'

class TestBineps < Test::Unit::TestCase

  context "bindeps" do

    setup do
      test_dir = File.dirname(__FILE__)
      @data_dir = File.join(test_dir, 'data')
    end

    should "identify and install missing dependencies" do
      test_yaml = File.join(@data_dir, 'fakebin.yaml')
      Bindeps.require test_yaml
      assert_equal 'success', `fakebin`.strip
    end

    should "identify dependencies that are missing" do
      test_yaml = File.join(@data_dir, 'neverinstalled.yaml')
      missing = Bindeps.missing test_yaml
      assert_equal 1, missing.length
      assert_equal 'neverinstalled', missing.first
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

    should "handle version output to stderr" do
      test_yaml = File.join(@data_dir, 'fakebin3.yaml')
      # install fakebin3
      Bindeps.require test_yaml
      # now Dependency should detect it as installed
      deps = YAML.load_file test_yaml
      deps.each_pair do |name, config|
        d = Bindeps::Dependency.new(name,
                                    config['binaries'],
                                    config['version'],
                                    config['url'])
        assert d.installed?('fakebin3')
        assert d.all_installed?
      end
    end

    should "fail when no download is specified for the local system" do

    end

    should "fallback to wget when curl is not available" do

    end

    should "fail when no downloader is available" do

    end

    should "initialize" do
      assert_nothing_raised do
        Bindeps::Dependency.new(
          'test',                     # name
          ['binary'],                 # binaries
          {                           # versionconfig
            'number' => 1,
            'command' => 'getversion'
          },
          {                           # urlconfig
            '64bit' => {
              'linux' => 'url',
              'unix' => 'url',
              'macosx' => 'url',
              'windows' => 'url',
            }
          },
          false                       # unpack
        )
      end
      assert_raise do
        Bindeps::Dependency.new(
          'test',                     # name
          'binary',                   # binaries is no longer an array
          {                           # versionconfig
            'number' => 1,
            'command' => 'getversion'
          },
          {                           # urlconfig
            '64bit' => {
              'linux' => 'url',
              'unix' => 'url',
              'macosx' => 'url',
              'windows' => 'url',
            }
          },
          false                       # unpack
        )
      end
    end

  end

end
