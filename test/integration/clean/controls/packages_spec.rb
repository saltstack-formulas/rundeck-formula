# frozen_string_literal: true

control 'rundeck package' do
  title 'should be installed'

  describe package(package_name) do
    it { should_not be_installed }
  end
end
