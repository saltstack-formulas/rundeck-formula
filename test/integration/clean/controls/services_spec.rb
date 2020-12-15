# frozen_string_literal: true

control 'rundeck service' do
  impact 0.5
  title 'should_not be running and enabled'

  describe service('rundeckd') do
    it { should_not be_installed }
    it { should_not be_enabled }
    it { should_not be_running }
  end
end
