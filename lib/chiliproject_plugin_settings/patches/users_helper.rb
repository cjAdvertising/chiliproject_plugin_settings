module ChiliprojectPluginSettings
  module Patches
    module UsersHelper
      extend Base

      def self.target
        ::UsersHelper
      end

      def self.included(base)
        base.send(:include, InstanceMethods)
        base.send(:include, PluginSettingsHelper)
        base.class_eval do
          alias_method_chain :user_settings_tabs, :plugin_settings
        end
      end

      module InstanceMethods
        def user_settings_tabs_with_plugin_settings
          tabs = user_settings_tabs_without_plugin_settings
          tabs + ChiliprojectPluginSettings.user_settings_tabs
        end
      end
    end
  end
end