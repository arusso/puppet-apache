require 'spec_helper'

describe( 'apache::mod::secure_cookie', :type => :class ) do
  let(:redhat_facts) {{ 'osfamily' => 'RedHat' }}
  let(:redhat6_facts) {{'operatingsystemrelease' => '6.5' }.merge(redhat_facts)}
  let(:redhat5_facts) {{'operatingsystemrelease' => '5.10'}.merge(redhat_facts)}

  context "on Red Hat" do
    context "Version 5" do
      let(:facts) {redhat5_facts}
      it do
        should contain_file('/etc/httpd/conf.d/secure_cookie.conf').with({
          'ensure' => 'present',
          'owner' => 'root',
          'group' => 'root',
          'mode' => '0444',
          'source' => 'puppet:///modules/apache/secure_cookie.conf',
          'notify' => 'Class[Apache::Service]',
        })
        should contain_file('/etc/httpd/conf.d/module-secure_cookie.conf').with({
          'ensure' => 'link',
          'target' => '/etc/httpd/conf.d/secure_cookie.conf',
        })
      end
    end
    context "Version 6" do
      let(:facts) {redhat6_facts}
      it do
        should contain_file('/etc/httpd/conf.d/secure_cookie.conf').with({
          'ensure' => 'present',
          'owner' => 'root',
          'group' => 'root',
          'mode' => '0444',
          'source' => 'puppet:///modules/apache/secure_cookie.conf',
          'notify' => 'Class[Apache::Service]',
        })
        should contain_file('/etc/httpd/conf.d/module-secure_cookie.conf').with({
          'ensure' => 'link',
          'target' => '/etc/httpd/conf.d/secure_cookie.conf',
        })
      end
    end
  end
end
