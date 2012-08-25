# encoding: utf-8

module ChiliprojectPluginSettings
  module Patches
    module ProjectsHelper
      extend Base

      def self.target
        ::ProjectsHelper
      end

      def self.included(base)
        base.send(:include, InstanceMethods)
        base.send(:include, PluginSettingsHelper)
        base.class_eval do
          alias_method_chain :project_settings_tabs, :plugin_settings
        end
      end

      module InstanceMethods
        def project_settings_tabs_with_plugin_settings
          tabs = project_settings_tabs_without_plugin_settings
          tabs + ChiliprojectPluginSettings.project_settings_tabs(@project)
        end
      end
    end
  end
end