# encoding: utf-8

class PluginSettingsController < ApplicationController
  unloadable

  def update

    # Find object (Project/User) by object_id.
    begin
      object = params[:object_name].camelize.constantize.find(params[:object_id])
    rescue ActiveRecord::RecordNotFound
      render_404 && return
    end

    # Set instance variable for object so the partial has it available.
    instance_variable_set "@#{params[:object_name]}", object

    # Fetch plugin settings options based on module name and object type.
    options = ChiliprojectPluginSettings.settings_options params[:module_name], params[:object_name]

    # Convert the model option to underscored symbol if it's a Class.
    model_sym = options[:model].is_a?(Symbol) ? options[:model] : options[:model].to_s.underscore.to_sym

    # Fetch plugin settings (or nil) from object via plugin_settings accessor.
    plugin_settings = object.plugin_settings[params[:module_name]]

    # Update attributes or create new plugin settings instance and save.
    if plugin_settings.nil?
      # Attributes will always have a link back to the model's id.
      attrs = params[model_sym].merge({"#{params[:object_name]}_id" => object.id})
      model_sym.to_s.camelize.constantize.new(attrs).save
    else
      plugin_settings.update_attributes params[model_sym]
    end

    # Render settings partial.
    render(:update) do |page|
      page.replace_html "tab-content-#{params[:module_name]}", :partial => options[:partial]
    end
  end
end