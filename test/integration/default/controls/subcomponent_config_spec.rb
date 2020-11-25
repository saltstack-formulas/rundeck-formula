# frozen_string_literal: true

control 'rundeck subcomponent configuration' do
  title 'should match desired lines'

  describe file('/etc/rundeck-subcomponent-formula.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') do
      should include(
        '# File managed by Salt at '\
        '<salt://rundeck/subcomponent/config/files/default/'\
        'subcomponent-example.tmpl.jinja>.'
      )
    end
    its('content') do
      should include(
        'This is another subcomponent example file from SaltStack '\
        'rundeck-formula.'
      )
    end
  end
end
