require 'serverspec'

set :backend, :exec

describe 'validate settings xml' do

  describe command('xmllint --noout /home/test1/.m2/settings.xml') do
    its(:exit_status) { should eq 0 }
  end

end
