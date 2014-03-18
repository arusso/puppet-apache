require 'spec_helper'

describe( 'apache::params', :type => :class ) do
  let(:redhat_facts) {{ 'osfamily' => 'RedHat' }}
  let(:redhat6_facts) {{'operatingsystemrelease' => '6.5' }.merge(redhat_facts)}
  let(:redhat5_facts) {{'operatingsystemrelease' => '5.10'}.merge(redhat_facts)}

  context "unhandled OS" do
    let(:facts) {{ 'osfamily' => 'SuperDuperOS' }}
    it do
       expect { should compile }.to raise_error(Puppet::Error,/not supported/)
    end
  end

  context "on Red Hat" do
    context "Version 5" do
      let(:facts) {redhat5_facts}
      it { should compile }
    end
    context "Version 6" do
      let(:facts) {redhat6_facts}
      it { should compile }
    end
  end
end
