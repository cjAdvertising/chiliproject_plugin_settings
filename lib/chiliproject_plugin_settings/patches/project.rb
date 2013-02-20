# encoding: utf-8

module ChiliprojectPluginSettings
  module Patches
    module Project
      extend ActiveSupport::Concern

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
