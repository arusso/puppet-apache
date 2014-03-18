require 'spec_helper'

describe( 'apache::vhost',:type => :define) do
  let(:redhat_facts) {{ 'osfamily' => 'RedHat' }}
  let(:redhat5_facts) {{'operatingsystemrelease' => '5.10'}.merge(redhat_facts)}
  let(:redhat6_facts) {{'operatingsystemrelease' => '6.5' }.merge(redhat_facts)}

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
