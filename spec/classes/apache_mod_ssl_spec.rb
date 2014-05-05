require 'spec_helper'

describe( 'apache::mod::ssl', :type => :class ) do
  let :pre_condition do
    'class { "apache": }'
  end

  let :default_facts do
    {
      :concat_basedir => '/spec/concat',
    }
  end

  context "on Red Hat" do
    let :redhat_facts do
      default_facts.merge({ 'osfamily' => 'RedHat' })
    end

    context "Version 5" do
      let :redhat5_facts do
        redhat_facts.merge({ :operatingsystemrelease => '5.10' })
      end

      let(:facts) {redhat5_facts}
      it do
        should contain_apache__mod('ssl')
        should contain_file('ssl.conf').with({
          'owner' => 'root',
          'path' => '/etc/httpd/conf.d/ssl.conf',
          'group' => 'root',
          'mode' => '0444',
          #'source' => 'puppet:///apache/ssl.conf',
        })
        should contain_file('module-ssl.conf').with({
          'ensure' => 'link',
          'path' => '/etc/httpd/conf.d/module-ssl.conf',
          'target' => '/etc/httpd/conf.d/ssl.conf',
        })
      end
    end
    context "Version 6" do
      let :redhat6_facts do
        redhat_facts.merge({ :operatingsystemrelease => '6.5' })
      end
      let(:facts) {redhat6_facts}
      it do
        should contain_apache__mod('ssl')
        should contain_file('ssl.conf').with({
          'owner' => 'root',
          'path' => '/etc/httpd/conf.d/ssl.conf',
          'group' => 'root',
          'mode' => '0444',
          #'source' => 'puppet:///apache/ssl.conf',
        })
        should contain_file('module-ssl.conf').with({
          'ensure' => 'link',
          'path' => '/etc/httpd/conf.d/module-ssl.conf',
          'target' => '/etc/httpd/conf.d/ssl.conf',
        })
      end
    end
  end
end
