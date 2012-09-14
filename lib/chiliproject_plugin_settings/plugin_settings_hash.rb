# encoding: utf-8

module ChiliprojectPluginSettings
  class PluginSettingsHash
    def initialize(object_name, object)
      @object_name = object_name
      @object = object
    end

    def [](module_name)
      return {} unless options = ChiliprojectPluginSettings.settings_options(module_name, @object_name)
      model = options[:model].is_a?(Symbol) ? options[:model].to_s.camelize.constantize : options[:model]
      model.send "find_by_#{@object_name}_id".to_sym, @object.id
    end
  end
end