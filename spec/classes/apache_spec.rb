require 'spec_helper'

describe( 'apache', :type => :class ) do
  let(:redhat_facts) {{ 'osfamily' => 'RedHat' }}
  let(:redhat6_facts) {{'operatingsystemrelease' => '6.5' }.merge(redhat_facts)}
  let(:redhat5_facts) {{'operatingsystemrelease' => '5.10'}.merge(redhat_facts)}

  context "on Red Hat" do
    context "Version 5" do
      let(:facts) { redhat5_facts }
      it do
        should contain_anchor('apache::start').that_comes_before('Class[apache::install]')
        should contain_apache__install.that_comes_before('Class[apache::config]')
        should contain_apache__config.that_notifies('Class[apache::service]')
        should contain_apache__service.that_comes_before('Anchor[apache::end]')
      end
    end
    context "Version 6" do
      let(:facts) { redhat6_facts }
      it do
        should contain_anchor('apache::start').that_comes_before('Class[apache::install]')
        should contain_apache__install.that_comes_before('Class[apache::config]')
        should contain_apache__config.that_notifies('Class[apache::service]')
        should contain_apache__service.that_comes_before('Anchor[apache::end]')
      end
    end
  end
end
