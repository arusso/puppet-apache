require 'spec_helper'

describe( 'apache::config', :type => :class ) do
  let(:redhat_facts) {{ 'osfamily' => 'RedHat' }}
  let(:redhat6_facts) {{'operatingsystemrelease' => '6.5' }.merge(redhat_facts)}
  let(:redhat5_facts) {{'operatingsystemrelease' => '5.10'}.merge(redhat_facts)}

  context "on Red Hat" do
    context "Version 5" do
      let(:facts) {redhat5_facts}
      it do
        should contain_file('/etc/httpd/conf/httpd.conf').with({
          'ensure' => 'file',
          'owner' => 'root',
          'group' => 'root',
          'mode' => '0444',
        })

        should contain_file('/etc/httpd/conf.d').with({
          'ensure' => 'directory',
          'force' => true,
          'purge' => true,
          'recurse' => true,
        })
      end
    end
    context "Version 6" do
      let(:facts) {redhat6_facts}
      it do
        should contain_file('/etc/httpd/conf/httpd.conf').with({
          'ensure' => 'file',
          'owner' => 'root',
          'group' => 'root',
          'mode' => '0444',
        })

        should contain_file('/etc/httpd/conf.d').with({
          'ensure' => 'directory',
          'force' => true,
          'purge' => true,
          'recurse' => true,
        })
      end
    end
  end
end
