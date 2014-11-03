require 'spec_helper'

describe 'maven' do

  context 'with package_ensure => 3.1.1' do
    let(:params) do {
      :package_ensure => '3.1.1'
    } end
    it { should contain_class('maven') }
    it {
      should contain_exec('install_maven_from_tar_gz').with(
        :command  => "wget -O - http://www.bizdirusa.com/mirrors/apache/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz | tar zxf -"
      )
    }
  end
end
