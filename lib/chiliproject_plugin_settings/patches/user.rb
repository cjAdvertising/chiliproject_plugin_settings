module ChiliprojectPluginSettings
  module Patches
    module User
      extend Base

      def self.target
        ::User
      end

      module InstanceMethods

        # Public: Shortcut to fetch plugin settings based on module name.
        #
        # Returns Object plugin settings instance or nil.
        def plugin_settings
          ChiliprojectPluginSettings::PluginSettingsHash.new :user, self
        end
      end
    end
  end
end
