require 'serverspec'

set :backend, :exec

describe 'verify maven' do

  describe file('/opt/apache-maven-3.1.1/bin/mvn') do
    it { should be_file }
    it { should be_executable }
  end

end
