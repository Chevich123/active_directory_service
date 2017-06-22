$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'active_directory_service/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'active_directory_service'
  s.version     = ActiveDirectoryService::VERSION
  s.authors     = ['Andrew Rogachevich']
  s.email       = ['andrey.rogachevich@azati.com']
  s.homepage    = 'https://github.com/Chevich123/active_directory_service'
  s.summary     = "Allow to check credentials with ActiveDirectory, to archive entity and to change user's password in Active Directory"
  s.description = "Allow to check credentials with ActiveDirectory, to archive entity and to change user's password in Active Directory"
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'net-ldap'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
end
