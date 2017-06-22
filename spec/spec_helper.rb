require 'active_directory_service'

RSpec.configure do |config|
  config.before(:suite) do
    ActiveDirectoryService.setup do |ads_config|
      ads_config.ldap_config = YAML.load_file(File.dirname(__FILE__) + '/fixtures/ads_setting.yml')
    end
  end
end
