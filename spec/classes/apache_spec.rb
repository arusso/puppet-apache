require 'spec_helper'

describe( 'apache', :type => :class ) do
  let :pre_condition do
    'include apache'
  end
  let :default_facts do
    {
      :concat_basedir => '/concat',
      :osfamily => 'RedHat',
      :operatingsystemrelease => '6.5',
    }
  end

  describe "os-independent" do
    context "check httpd file contents" do
      let :facts do
        default_facts
      end

      [
        /^Include \/etc\/httpd\/conf\/ports.conf$/,
      ].each do |check|
        it do
          should contain_file('/etc/httpd/conf/httpd.conf').with_content(check)
        end
      end
    end

    context "check for ports file" do
      let :facts do
        default_facts
      end

      it do
        should contain_concat('/etc/httpd/conf/ports.conf')
      end
    end
  end
end
