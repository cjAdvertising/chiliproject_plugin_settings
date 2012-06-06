require 'redmine'
require 'dispatcher'

require_dependency 'chiliproject_plugin_settings'

Dispatcher.to_prepare :chiliproject_plugin_settings do
  require_dependency "chiliproject_plugin_settings"

  require_dependency "projects_helper"
  require "chiliproject_plugin_settings/patches/projects_helper_patch"
  unless ProjectsHelper.included_modules.include?(ChiliprojectPluginSettings::Patches::ProjectsHelperPatch)
    ProjectsHelper.send(:include, ChiliprojectPluginSettings::Patches::ProjectsHelperPatch) 
  end

  require_dependency "users_helper"
  require "chiliproject_plugin_settings/patches/users_helper_patch"
  unless UsersHelper.included_modules.include?(ChiliprojectPluginSettings::Patches::UsersHelperPatch)
    UsersHelper.send(:include, ChiliprojectPluginSettings::Patches::UsersHelperPatch) 
  end
end

Redmine::Plugin.register :chiliproject_plugin_settings do
  name 'Chiliproject Plugin Settings plugin'
  author 'cj Advertising, LLC'
  description 'Easily adds plugin settings forms'
  version '0.0.1'
  url 'http://cjadvertising.com'
  author_url 'http://cjadvertising.com'
end
