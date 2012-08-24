require 'redmine'
require 'chiliproject_plugin_settings/patches/base'
require 'chiliproject_plugin_settings/patches/plugin'

module ChiliprojectPluginSettings

  @@registered = {}

  # Public: Register a plugin module settings for a given object.
  #
  # Options:
  # controller - Symbol name of settings controller to use instead of default (default: :plugin_settings)
  # action     - Symbol name of the action on the settings controller (default: :update)
  # model      - Symbol or Class model to use for the settings (default: :<module>_<object>_settings)
  # partial    - Partial to render for the settings view (default: "<object.pluralize>/settings/<module>")
  # permission - Symbol permission required (default: :manage_<module>)
  # label      - Symbol label to use for the settings tab (default: :label_<module>)
  #
  # Examples:
  #
  #   # vendor/plugin/chiliproject_example/init.rb
  #   Redmine::Plugin.register :chiliproject_example do
  #
  #     # ...
  #
  #     project_module :example do
  #       permission :manage_example, {:example_settings => :project_settings}
  #     end
  #   end
  #
  #   Dispatcher.to_prepare :chiliproject_example do
  #     require_dependency "chiliproject_plugin_settings"
  #     ChiliprojectPluginSettings.register :example, :project, :controller => :example_settings
  #   end
  #
  # module_name - String or Symbol project module name
  # object_name - String or Symbol object name or Array of names
  # options     - Hash options
  # 
  # Returns nothing.
  def self.register(module_name, object_name, options={})
    @@registered[module_name.to_sym] ||= {}
    (object_name.is_a?(Array) ? object_name : [object_name]).each do |o|
      @@registered[module_name.to_sym][o.to_sym] = options.symbolize_keys
    end
  end

  def self.registered?(module_name, object_name)
    (m = @@registered[module_name.to_sym]) && m[object_name.to_sym]
  end

  def self.settings_tabs(object_name)
    @@registered.select { |k, v| v.key? object_name.to_sym }.keys.map do |m|
      options = settings_options m, object_name
      { :name => m.to_s, :partial => options[:partial], :label => options[:label] }
    end
  end

  def self.user_settings_tabs
    settings_tabs(:user)
  end

  def self.project_settings_tabs(project=nil)
    # TODO: check a permission here too?
    return settings_tabs(:project) if project.nil?
    settings_tabs(:project).select { |t| project.module_enabled?(t[:name].to_sym) }
  end

  def self.settings_options(module_name, object_name)
    return unless registered? module_name, object_name
    {
      :controller => :plugin_settings,
      :action => :update,
      :model => "#{module_name}_#{object_name}_settings".to_sym,
      :partial => "#{object_name.to_s.pluralize}/settings/#{module_name}",
      :label => "label_#{module_name}".to_sym,
      :permission => "manage_#{module_name}".to_sym
    }.merge @@registered[module_name.to_sym][object_name.to_sym]
  end
end