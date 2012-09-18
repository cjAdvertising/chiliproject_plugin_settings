# encoding: utf-8

module ChiliprojectPluginSettings
  module Patches
    module ProjectsController
      extend Base

      def self.target
        ::ProjectsController
      end

      def self.included(base)
        base.class_eval do
          helper :plugin_settings
        end
      end
    end
  end
end