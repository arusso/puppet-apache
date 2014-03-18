require 'spec_helper'

describe( 'apache::mod::php', :type => :class ) do
  let(:redhat_facts) {{ 'osfamily' => 'RedHat' }}
  let(:redhat6_facts) {{'operatingsystemrelease' => '6.5' }.merge(redhat_facts)}
  let(:redhat5_facts) {{'operatingsystemrelease' => '5.10'}.merge(redhat_facts)}

  context "on Red Hat" do
    context "Version 5" do
      let(:facts) {redhat5_facts}
      it do
        should contain_file('/etc/httpd/conf.d/php.conf').with({
          'ensure' => 'present',
          'owner' => 'root',
          'group' => 'root',
          'mode' => '0444',
          'replace' => false,
          'source' => 'puppet:///modules/apache/php.conf',
          'notify' => 'Class[Apache::Service]',
        })
        should contain_file('/etc/httpd/conf.d/module-php.conf').with({
          'ensure' => 'link',
          'target' => '/etc/httpd/conf.d/php.conf',
        })
      end
    end
    context "Version 6" do
      let(:facts) {redhat6_facts}
      it do
        should contain_file('/etc/httpd/conf.d/php.conf').with({
          'ensure' => 'present',
          'owner' => 'root',
          'group' => 'root',
          'mode' => '0444',
          'replace' => false,
          'source' => 'puppet:///modules/apache/php.conf',
          'notify' => 'Class[Apache::Service]',
        })
        should contain_file('/etc/httpd/conf.d/module-php.conf').with({
          'ensure' => 'link',
          'target' => '/etc/httpd/conf.d/php.conf',
        })
      end
    end
  end
end
