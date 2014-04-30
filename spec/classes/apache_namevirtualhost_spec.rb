require 'spec_helper'

describe( 'apache::namevirtualhost', :type => :class ) do
  let(:redhat_facts) {{ 'osfamily' => 'RedHat' }}
  let(:redhat6_facts) {{'operatingsystemrelease' => '6.5' }.merge(redhat_facts)}
  let(:redhat5_facts) {{'operatingsystemrelease' => '5.10'}.merge(redhat_facts)}

  context "on Red Hat" do
    context "Version 5" do
      let(:facts) {redhat5_facts}
      it do
        should contain_file('/etc/httpd/conf.d/module-namevirtualhost.conf').with({
          'ensure' => 'present',
          'owner' => 'root',
          'group' => 'root',
          'mode' => '0444',
          'content' => "NameVirtualHost *:80\nNameVirtualHost *:443\n",
          'notify' => 'Class[Apache::Service]',
        })
      end
    end
    context "Version 6" do
      let(:facts) {redhat6_facts}
      it do
        should contain_file('/etc/httpd/conf.d/module-namevirtualhost.conf').with({
          'ensure' => 'present',
          'owner' => 'root',
          'group' => 'root',
          'mode' => '0444',
          'content' => "NameVirtualHost *:80\nNameVirtualHost *:443\n",
          'notify' => 'Class[Apache::Service]',
        })
      end
    end
  end
end
