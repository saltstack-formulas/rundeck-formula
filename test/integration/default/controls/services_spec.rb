# frozen_string_literal: true

control 'rundeck service' do
  impact 0.5
  title 'should be running and enabled'

  describe service('rundeckd') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
