module ChiliprojectPluginSettings
  module Patches
    module Plugin
      extend Base

      def self.target
        Redmine::Plugin
      end

      module InstanceMethods

        # Public: Shortcut to define plugin project settings.
        #
        # module_name - String name of the project module
        # options     - Hash options for ChiliprojectPluginSettings.register.
        #
        # Returns nothing.
        def project_settings(module_name, options={})
          ChiliprojectPluginSettings.register module_name, :project, options
        end

        # Public: Shortcut to define plugin user settings.
        #
        # module_name - String name of the project module
        # options     - Hash options for ChiliprojectPluginSettings.register.
        #
        # Returns nothing.
        def user_settings(module_name, options={})
          ChiliprojectPluginSettings.register module_name, :user, options
        end
      end
    end
  end
end
