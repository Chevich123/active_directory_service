module ActiveDirectoryService
  class Service
    attr_accessor :username, :password, :ssl, :result
    attr_accessor :ldap_config

    def initialize(username, password, ssl = false)
      self.ldap_config = ActiveDirectoryService.ldap_config
      self.result = nil
      self.username = username
      self.password = password
      self.ssl = ssl
    end

    def error_message
      result.present? ? result.error_message : nil
    end

    def ldap_entry(fields = nil)
      treebase = ldap_config['base']
      filter = Net::LDAP::Filter.eq(ldap_config['attribute'], username)
      attrs = fields || %w[mail givenName sn]
      params = {
        base: treebase,
        filter: filter,
        attributes: attrs,
        return_result: true
      }
      ldap.search(params) do |entry|
        return entry
      end
      {}
    end

    def valid_ldap_authentication?
      ldap.bind
    end

    private

    def ldap
      @ldap ||= compose_ldap
    end

    def dn
      "#{ldap_config['attribute']}=#{username},#{ldap_config['base']}"
    end

    def compose_ldap
      Net::LDAP.new(connection_params).tap do |ldap|
        ldap.host = ldap_config['host']
        ldap.port = ssl ? ldap_config['ssl_port'] : ldap_config['basic_port']
        ldap.auth(dn, password)
      end
    end

    def connection_params
      if ssl
        {
          encryption: {
            method: :simple_tls,
            tls_options: { ca_file: ldap_config['ca_file_path'],
                           verify_mode: ldap_config['verify_certificate'] ? OpenSSL::SSL::VERIFY_PEER : OpenSSL::SSL::VERIFY_NONE,
                           ssl_version: ldap_config['ssl_version'] }
          }
        }
      else
        {}
      end
    end

    def change_ldap_password(new_password)
      old_pass = microsoft_encode_password(password)
      new_pass = microsoft_encode_password(new_password)

      # ops = [
      #   [:replace, :unicodePwd, [old_pass, new_pass]],
      # ]
      ops = [
        [:delete, :unicodePwd, [old_pass]],
        [:add, :unicodePwd, [new_pass]]
      ]
      self.result = ldap.modify(dn: dn, operations: ops)
      result.success?
    end

    def microsoft_encode_password(pwd)
      ret = ''
      pwd = '"' + pwd + '"'
      pwd.length.times { |i| ret += "#{pwd[i..i]}\000" }
      ret
    end
  end
end
