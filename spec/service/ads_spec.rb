require 'spec_helper'

RSpec.describe ActiveDirectoryService do
  subject { ActiveDirectoryService::Service.new('username', 'password') }

  it 'should exists' do
    expect(subject).to_not be_nil
  end
end
