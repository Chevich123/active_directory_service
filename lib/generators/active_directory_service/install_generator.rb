module ActiveDirectoryService
  class InstallGenerator < Rails::Generators::Base
    desc "This generator creates an initializer file at config/initializers"

    source_root File.expand_path("../templates", __FILE__)

    def create_ads_setting_config
      copy_file "ads_setting.yml", "config/ads_setting.yml"
    end

    def create_default_ads_settings
      copy_file "active_directory_service.rb", "config/initializers/active_directory_service.rb"
    end

  end
end
