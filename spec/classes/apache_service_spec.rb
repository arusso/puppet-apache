require 'spec_helper'

describe 'apache::service', :type => :class do
  let(:redhat_facts) {{ 'osfamily' => 'RedHat' }}
  let(:redhat6_facts) {{'operatingsystemrelease' => '6.5' }.merge(redhat_facts)}
  let(:redhat5_facts) {{'operatingsystemrelease' => '5.10'}.merge(redhat_facts)}

  describe "os independent configurations" do
    context "set service_ensure = noop and service_enable = noop" do
      let :params do
        {
          :service_ensure => 'noop',
          :service_enable => 'noop',
        }
      end
      it do
        should contain_service('httpd').only_with_name('httpd')
      end
    end

    context "set service_ensure = noop and service_enable = false" do
      let :params do
        {
          :service_ensure => 'noop',
          :service_enable => true,
        }
        it do
          should contain_service('httpd').only_with({
            :name => 'httpd',
            :enable => true,
          })
        end
      end
    end

    context "set service_ensure = 'stopped' and service_enable = noop" do
      let :params do
        {
          :service_ensure => 'stopped',
          :service_enable => 'noop',
        }
        it do
          should contain_service('httpd').only_with({
            :name => 'httpd',
            :ensure => 'stopped',
          })
        end
      end
    end

    context "default behavior" do
      it do
        should contain_service('httpd').with({
          'ensure' => 'running',
          'name' => 'httpd',
          'enable' => true,
        })
      end
    end
  end
end
