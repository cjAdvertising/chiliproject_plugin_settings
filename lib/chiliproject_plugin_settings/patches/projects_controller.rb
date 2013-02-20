# encoding: utf-8

module ChiliprojectPluginSettings
  module Patches
    module ProjectsController
      extend ActiveSupport::Concern

      included do
        helper :plugin_settings
      end
    end
  end
end