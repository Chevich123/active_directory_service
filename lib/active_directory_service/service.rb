module ActiveDirectoryService
  class Service
    attr_accessor :username, :password, :ssl, :result

    def initialize(username, password, ssl = false)
      self.result = nil
      self.username = username
      self.password = password
      self.ssl = ssl
    end

    def error_message
      result.present? ? result.error_message : nil
    end

    def ldap_entry(fields = nil)
      treebase = 'ou=ssousers,dc=corp,dc=itibo,dc=com'
      filter = Net::LDAP::Filter.eq('cn', username)
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
      "cn=#{username},ou=ssousers,dc=corp,dc=itibo,dc=com"
    end

    def compose_ldap
      Net::LDAP.new(connection_params).tap do |ldap|
        ldap.host = 'corp.itibo.com'
        ldap.port = ssl ? 636 : 389
        ldap.auth(dn, password)
      end
    end

    def connection_params
      if ssl
        {
          encryption: {
            method: :simple_tls,
            tls_options: { ca_file: '/etc/ssl/certs/corpRootCa.cer',
                           verify_mode: OpenSSL::SSL::VERIFY_NONE,
                           ssl_version: 'TLSv1_1' }
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
