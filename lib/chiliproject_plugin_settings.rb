
module ChiliprojectPluginSettings
  def self.settings_tabs(key_name)
    @@registered ||= {}
    @@registered.select { |m, k| k.include? key_name.to_sym }.keys.map do |m|
      { :name => m.to_s, :partial => "#{key_name.to_s.pluralize}/settings/#{m}", :label => "label_#{m}".to_sym }
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

  def self.register(module_name, key_name)
    @@registered ||= {}
    # Ensure array of symbols
    @@registered[module_name.to_sym] = key_name.is_a?(Array) ? key_name.map { |k| k.to_sym } : [key_name.to_sym]
  end
end