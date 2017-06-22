require 'net/ldap'
require 'active_directory_service/service'

module ActiveDirectoryService
  # A path to YAML config file or a Proc that returns a
  # configuration hash
  mattr_accessor :ldap_config_path
  @@ldap_config_path = ''

  mattr_accessor :ldap_config_path

  def self.setup
    yield self
    p "ldap_config = #{ldap_config_path}"

    @@ldap_config = YAML.load_file(Rails.root.join(ldap_config_path))

    p @@ldap_config
  end
end
