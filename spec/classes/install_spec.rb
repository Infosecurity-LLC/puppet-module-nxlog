require 'spec_helper'

describe 'nxlog::install' do
  context 'On a RedHat OS' do
    let :facts do
      {
        kernel: 'Linux',
        osfamily: 'RedHat',
        operatingsystem: 'RedHat',
        concat_basedir: File.join(Puppet[:vardir], 'concat'),
      }
    end

    context 'with the default package' do
      let :pre_condition do
        "class {'nxlog':
          conf_dir   => '/opt/nxlog/etc/nxlog/conf',
          conf_file  => 'nxlog.conf',
          nxlog_root => '/opt/nxlog/etc/nxlog',
        }"
      end

      it 'installs the latest version of NXLog by default' do
        is_expected.to contain_package('nxlog-ce').with(
          'ensure' => 'latest',
        )
      end

      it "uses '/opt/nxlog/etc/nxlog/conf/nxlog.conf' as it's config file" do
        is_expected.to contain_concat('/opt/nxlog/etc/nxlog/conf/nxlog.conf')
      end
    end

    context 'with a different package name and ensure_setting => present' do
      let :pre_condition do
        "class {'nxlog':
          conf_dir       => '/opt/nxlog/etc/nxlog/conf',
          conf_file      => 'nxlog.conf',
          ensure_setting => 'present',
          nxlog_root     => '/opt/nxlog/etc/nxlog',
          package_name   => 'nxlog-custom-build',
        }"
      end

      it 'installs the custom version of NXLog wit ensure => present' do
        is_expected.to contain_package('nxlog-custom-build').with(
          'ensure' => 'present',
        )
      end
    end
  end

  context 'On Windows' do
    let :facts do
      {
        kernel: 'windows',
        osfamily: 'windows',
        operatingsystem: 'windows',
        concat_basedir: File.join(Puppet[:vardir], 'concat'),
      }
    end

    let :pre_condition do
      "class {'nxlog':
        conf_dir   => 'C:/nxlog/conf',
        conf_file  => 'nxlog.conf',
        nxlog_root => 'C:/nxlog',
      }"
    end

    it 'installs the latest version of NXLog by default' do
      is_expected.to contain_package('nxlog').with(
        'ensure'   => 'latest',
        'provider' => 'chocolatey',
      )
    end

    it "uses 'C:/nxlog/conf/nxlog.conf' as it's config file" do
      is_expected.to contain_concat('C:/nxlog/conf/nxlog.conf')
    end
  end
end
