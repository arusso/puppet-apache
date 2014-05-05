require 'spec_helper'

describe( 'apache::vhost',:type => :define) do
  let :pre_condition do
    'include apache'
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
end
