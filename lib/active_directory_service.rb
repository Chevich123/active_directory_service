require 'net/ldap'
require 'yaml'
require 'active_directory_service/service'
require 'active_support'

module ActiveDirectoryService
  DEFAULT_LDAP_CONFIG = {
    host: 'localhost',
    basic_port: 389,
    ssl_port: 636,
    attribute: 'cn',
    ca_file_path: '/etc/ssl/certs/corpRootCa.cer',
    verify_certificate: false,
    ssl_version: 'TLSv1_1',
    base: 'ou=people,dc=test,dc=com',
    ssl: false
  }.freeze

  # A path to YAML config file or a Proc that returns a
  # configuration hash
  mattr_accessor :ldap_config

  def self.setup
    self.ldap_config = DEFAULT_LDAP_CONFIG
    yield self
  end
end
