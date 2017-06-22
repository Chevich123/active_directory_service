require 'net/ldap'
require 'active_directory_service/service'

module ActiveDirectoryService
  # A path to YAML config file or a Proc that returns a
  # configuration hash
  mattr_accessor :ldap_config
  @@ldap_config = "#{Rails.root}/config/ldap.yml"


  def self.setup
    yield self
    p "ldap_config = #{ldap_config}"
  end
end
