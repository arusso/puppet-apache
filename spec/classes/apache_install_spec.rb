require 'spec_helper'

describe( 'apache::install', :type => :class ) do
  let(:redhat_facts) {{ 'osfamily' => 'RedHat' }}
  let(:redhat6_facts) {{'operatingsystemrelease' => '6.5' }.merge(redhat_facts)}
  let(:redhat5_facts) {{'operatingsystemrelease' => '5.10'}.merge(redhat_facts)}

  context "on Red Hat" do
    context "Version 5" do
      let(:facts) {redhat5_facts}
      it do
        should contain_package('httpd').with_ensure('present')
      end
    end
    context "Version 6" do
      let(:facts) {redhat6_facts}
      it do
        should contain_package('httpd').with_ensure('present')
      end
    end
  end
end
