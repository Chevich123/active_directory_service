ActiveDirectoryService.setup do |config|
  # put here any custom config params
  config.ldap_config = YAML.load_file(Rails.root.join('config', 'ads_setting.yml'))[Rails.env]
end

# modify should return more parseable answer not just boolean result
module Net
  class LDAP
    def modify(args)
      instrument 'modify.net_ldap', args do |_payload|
        @result = use_connection(args) do |conn|
          conn.modify(args)
        end
        @result
      end
    end
  end
end
