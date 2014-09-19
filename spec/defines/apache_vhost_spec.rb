require 'spec_helper'

describe( 'apache::vhost',:type => :define) do
  let :pre_condition do
    'require ::apache::params'
  end

  let :default_facts do
    {
      :concat_basedir => '/spec/concat',
    }
  end


  let :redhat_facts do
    default_facts.merge({ 'osfamily' => 'RedHat' })
  end

  let :redhat5_facts do
    redhat_facts.merge({ 'operatingsystemrelease' => '5.10' })
  end

  context 'simple vhost' do
    let(:title) { 'www.example.com' }
    let(:facts) { redhat5_facts }
    it do
      should contain_file('/etc/httpd/conf.d/vhost-www.example.com.include').with({
        'owner' => 'root',
        'group' => 'root',
        'mode' => '0644',
        'source' => 'puppet:///modules/apache/vhost.include',
        'replace' => false,
      })
      should contain_file('/etc/httpd/conf.d/vhost-1-www.example.com.conf').with({
        'ensure' => 'file',
        'owner' => 'root',
        'group' => 'root',
        'mode' => '0444',
      })
    end
  end

  context 'use a custom template' do
    let(:title) { 'www.example.com' }
    let(:facts) { redhat5_facts }
    let :params do
      {
        'vhost_conf_template' => 'apache/test-only.erb',
        'vhost_conf_source' => 'puppet:///modules/apache/some/other/file.conf',
      }
    end

    it do
      should contain_file('/etc/httpd/conf.d/vhost-1-www.example.com.conf').with({
        :source => nil,
        :content => /pain/,
      })
    end
  end

  context 'use a custom source' do
    let(:title) { 'www.example.com' }
    let(:facts) { redhat5_facts }
    let :params do
      {
        'vhost_conf_source' => 'puppet:///modules/apache/test-only.conf',
      }
    end

    it do
      should contain_file('/etc/httpd/conf.d/vhost-1-www.example.com.conf').with({
        :source => 'puppet:///modules/apache/test-only.conf',
      })
    end
  end

  context 'do not provide an include file' do
    let(:title) { 'www.example.com' }
    let(:facts) { redhat5_facts }
    let :params do
      {
        :provide_include => false,
      }
    end

    it do
      should_not contain_file('/etc/httpd/conf.d/vhost-www.example.com.include')
    end
  end

  context 'default provide_include behavior' do
    let(:title) { 'www.example.com' }
    let(:facts) { redhat5_facts }
    it do
      should contain_file('/etc/httpd/conf.d/vhost-www.example.com.include')
    end
  end

  context 'default raw config' do
    let(:title) { 'www.example.com' }
    let(:facts) { redhat5_facts }
    let :params do
      {
        'ssl' => true,
        'ssl_crt_file' => '/tmp/cert.crt',
        'ssl_key_file' => '/tmp/key.key',
        'ssl_cert_resource' => 'noset',
      }
    end
    it do
      lines = [
        /^SSL RAW CONFIG LINE 1$/,
        /^SSL RAW CONFIG LINE 2$/,
        /^RAW CONFIG LINE 1$/,
        /^RAW CONFIG LINE 2$/,
      ]

      lines.each do |line|
        should contain_file('/etc/httpd/conf.d/vhost-1-www.example.com.conf').
          without({ :content => line })
      end
    end
  end

  context 'provide raw config' do
    let(:title) { 'www.example.com' }
    let(:facts) { redhat5_facts }
    let :params do
      {
        'ssl' => true,
        'ssl_raw' => "SSL RAW CONFIG LINE 1\nSSL RAW CONFIG LINE 2\n",
        'raw' => "RAW CONFIG LINE 1\nRAW CONFIG LINE 2\n",
        'ssl_crt_file' => '/tmp/cert.crt',
        'ssl_key_file' => '/tmp/key.key',
        'ssl_cert_resource' => 'noset',
      }
    end
    it do
      lines = [
        /^SSL RAW CONFIG LINE 1$/,
        /^SSL RAW CONFIG LINE 2$/,
        /^RAW CONFIG LINE 1$/,
        /^RAW CONFIG LINE 2$/,
      ]

      lines.each do |line|
        should contain_file('/etc/httpd/conf.d/vhost-1-www.example.com.conf').
          with({ :content => line })
      end
    end
  end

  context 'apache file naming' do
    let(:title) { 'www.example.com' }
    let(:facts) { redhat5_facts }
    let :params do
      {
        'ssl' => true,
        'ssl_crt_file' => '/tmp/cert.crt',
        'ssl_key_file' => '/tmp/key.key',
        'ssl_cert_resource' => 'noset',
        'server_name' => 'www2.example.com',
      }
    end
    it do
      should contain_file('/etc/httpd/conf.d/vhost-1-www.example.com.conf')
    end
  end
end
