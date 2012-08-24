module PluginSettingsHelper
  def plugin_settings_form_for(module_name, object_name, form_options={}, &block)
    object = instance_variable_get "@#{object_name}"
    options = ChiliprojectPluginSettings.settings_options module_name, object_name
    form_options = {
      :url => {
        :controller => options[:controller], 
        :action => options[:action], 
        :module_name => module_name,
        :object_name => object_name,
        :object_id => object.id
      },
      :builder => TabularFormBuilder,
      :lang => current_language
    }.merge form_options

    model_sym = options[:model].is_a?(Symbol) ? options[:model] : options[:model].to_s.underscore.to_sym

    remote_form_for options[:model], object.plugin_settings[module_name], form_options, &block
  end

  def project_plugin_settings_form_for(module_name, form_options={}, &block)
    plugin_settings_form_for module_name, :project, form_options, &block
  end

  def user_plugin_settings_form_for(module_name, form_options={}, &block)
    plugin_settings_form_for module_name, :user, form_options, &block
  end

  def plugin_settings_error_messages_for(module_name, object_name)
    options = ChiliprojectPluginSettings.settings_options module_name, object_name
    error_messages_for options[:model]
  end

  def project_plugin_settings_error_messages_for(module_name)
    plugin_settings_error_messages_for module_name, :project
  end

  def user_plugin_settings_error_messages_for(module_name)
    plugin_settings_error_messages_for module_name, :project
  end
end