module ChiliprojectPluginSettings
  module Patches
    module Project
      extend Base

      def self.target
        ::Project
      end

      module InstanceMethods

        # Public: Shortcut to fetch plugin settings based on module name.
        #
        # Returns Object plugin settings instance or nil.
        def plugin_settings
          ChiliprojectPluginSettings::PluginSettingsHash.new :project, self
        end
      end
    end
  end
end
