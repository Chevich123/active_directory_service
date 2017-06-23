# ActiveDirectoryService
There are no easy ways to modify user's password in Active Directory.
The problem is in leak of documentation with ActiveDirectory.
There are some rules for modify password in AD
* Ldap bind for modification have to be established through ssl
* There have to be two operations (delete + add) instead of modify
* Both passwords (old & new) have to be encoded with using the special way.
* Self-signed certificates have to be non verified and path to certificate have to be correctly noticed

This gem may be useful not only for changing password in ActiveDirectory but also for authorize user against ActiveDirectory

## Usage

In the Gemfile for your application:

    gem 'active_directory_service'

To get the latest version, pull directly from github instead of the gem:

    gem 'active_directory_service', git: 'https://github.com/Chevich123/active_directory_service.git'
    
Create service with credentials and validate it with Active Directory:

    service = ActiveDirectoryService::Service.new(username, password)
    service.valid_ldap_authentication?
    
Create ssl-secured service with credentials and change password:

    service = ActiveDirectoryService::Service.new(username, old_password, true)
    result = service.change_ldap_password(new_password)
    
Active Directory have many restrictions and constraints and can refuse to change password. To see error message call       
    
    service.error_message

## Installation
```bash
$ rails generate active_directory_service:install
```

Set up AD params with file config/ads_setting.yml:
 * host: localhost
 * basic_port: 389
 * ssl_port: 636
 * attribute: cn
 * ca_file_path: /etc/ssl/certs/corpRootCa.cer
 * verify_certificate: false
 * ssl_version: TLSv1_1
 * base: ou=ssousers,dc=corp,dc=company,dc=com
 * ssl: false

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
