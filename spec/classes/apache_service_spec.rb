require 'spec_helper'

describe 'apache::service', :type => :class do
  let :base_facts do
    {
      :concat_basedir => '/concat',
    }
  end

  let :redhat_facts do
    base_facts.merge({
      :osfamily => 'RedHat',
    })
  end

  let :redhat5_facts do
    redhat_facts.merge({
      :operatingsystemrelease => '5.10',
    })
  end

  let :redhat6_facts do
    redhat_facts.merge({
      :operatingsystemrelease => '6.5',
    })
  end

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
      let :pre_condition do
        [
          'file { "/etc/httpd/conf/ports.conf": }',
          'file { "/etc/httpd/conf/httpd.conf": }',
        ]
      end
      it do
        should contain_service('httpd').with({
          'ensure' => 'running',
          'name' => 'httpd',
          'enable' => true,
        })
      end
    end

    context "ensure we subscribe to vhosts when ensure is not managed" do
      let :params do
        {
          'service_ensure' => 'noop',
        }
      end
      let :facts do
         redhat5_facts
      end
      let :pre_condition do
        [
          'include apache::params',
          'file { "/etc/httpd/conf/ports.conf": }',
          'file { "/etc/httpd/conf/httpd.conf": }',
          'apache::vhost { "www.example.com": }',
        ]
      end
      it do
        should_not contain_apache__vhost('www.example.com').
          with_notify('Service[httpd]')

        should_not contain_file('/etc/httpd/conf/httpd.conf').
          with_notify('Service[httpd]')

        should_not contain_file('/etc/httpd/conf/ports.conf').
          with_notify('Service[httpd]')
      end
    end

    context "ensure we subscribe to vhosts when ensure is managed" do
      let :params do
        {
          'service_ensure' => true,
        }
      end
      let :facts do
         redhat5_facts
      end
      let :pre_condition do
        [
          'include apache::params',
          'file { "/etc/httpd/conf/ports.conf": }',
          'file { "/etc/httpd/conf/httpd.conf": }',
          'apache::vhost { "www.example.com": }',
        ]
      end
      it do
        should contain_apache__vhost('www.example.com').
          with_notify('Service[httpd]')

        should contain_file('/etc/httpd/conf/httpd.conf').
          with_notify('Service[httpd]')

        should contain_file('/etc/httpd/conf/ports.conf').
          with_notify('Service[httpd]')
      end
    end
  end
end
