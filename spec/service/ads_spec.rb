require 'active_directory_service/service'

RSpec.describe ActiveDirectoryService do
  it 'should exists' do
    game = ActiveDirectoryService::Service.new('username', 'password')
    expect(game).to_not be_nil
  end
end
