require 'redmine'
require 'dispatcher'
require 'chiliproject_plugin_settings'

Redmine::Plugin.register :chiliproject_plugin_settings do
  name 'Chiliproject Plugin Settings plugin'
  author 'cj Advertising, LLC'
  description 'Easily adds plugin settings forms'
  version '0.0.1'
  url 'http://cjadvertising.github.com/chiliproject_plugin_settings/'
  author_url 'http://cjadvertising.com'

  ChiliprojectPluginSettings::Patches::Plugin.patch
end

Dispatcher.to_prepare :chiliproject_plugin_settings do
  ChiliprojectPluginSettings::Patches::ProjectsHelper.patch
end