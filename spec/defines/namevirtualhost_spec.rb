require 'spec_helper'

describe 'apache::namevirtualhost', :type => :define do
  let :pre_condition do
    [
      'class { "apache": }',
    ]
  end

  context 'red hat systems' do
    let :facts do
      {
        'osfamily' => 'RedHat',
        'operatingsystemrelease' => '6.5',
        'concat_basedir' => '/spec/concat',
      }
    end
    let(:title) { '*:80' }
    it do
      should contain_concat__fragment('Namevirtualhost *:80').
        with_content("NameVirtualHost *:80\n")
    end
  end
end
