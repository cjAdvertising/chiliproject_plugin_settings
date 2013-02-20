# encoding: utf-8

module ChiliprojectPluginSettings
  module Patches
    module UsersHelper
      extend ActiveSupport::Concern

      included do
        include InstanceMethods
        include PluginSettingsHelper
        alias_method_chain :user_settings_tabs, :plugin_settings
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