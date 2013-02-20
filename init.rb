require 'chiliproject_plugin_settings'

Redmine::Plugin.register :chiliproject_plugin_settings do
  name 'Chiliproject Plugin Settings plugin'
  author 'cj Advertising, LLC'
  description 'Easily adds plugin settings forms'
  version '0.0.1'
  url 'https://github.com/cjAdvertising/chiliproject_plugin_settings'
  author_url 'http://cjadvertising.com'
end

RedmineApp::Application.config.to_prepare do
  Project.send :include, ChiliprojectPluginSettings::Patches::Project
  ProjectsHelper.send :include, ChiliprojectPluginSettings::Patches::ProjectsHelper
  ProjectsController.send :include, ChiliprojectPluginSettings::Patches::ProjectsController
  User.send :include, ChiliprojectPluginSettings::Patches::User
  UsersHelper.send :include, ChiliprojectPluginSettings::Patches::UsersHelper
end