
module ChiliprojectPluginSettingsHelper

  include ApplicationHelper
  include ProjectsHelper

  def self.included(base)
    base.class_eval do
      if respond_to? :before_filter
        before_filter :find_plugin_settings, :only => [:project_settings, :user_settings]
        # before_filter :authorize_global, :only => :user_settings
      end
    end
  end

  # Controller is assumed to be named the same as project module!!! ie. AnalyticsController
  def find_plugin_settings
    begin
      key_name = params[:action].gsub /_settings/, ''
      key_obj = key_name.camelize.constantize.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_404
    else
      self.instance_variable_set "@#{key_name}", key_obj
      params_name = "#{params[:controller]}_#{key_name}_settings"
      inst_var_name = "@#{params_name}"
      inst_var = params_name.camelize.constantize.find(:first, :conditions => ["#{key_name}_id =?", key_obj.id])
      self.instance_variable_set inst_var_name, inst_var
    end
  end


  # Public: Update or create settings from a remote form.
  #
  # module_name - The project module name as string or symbol.
  # key_name    - The name of the settings model's foreign key field.
  # extra_attrs - Extra attributes to pass to the settings constructor.
  #
  # Examples
  #
  #  # Given the following model:
  #  class PollsProjectSettings < ActiveRecord::Base
  #    belongs_to :project
  #    validates_presence_of :project, :anonymous
  #  end
  #
  #  # The following call could be made:
  #  update_or_create_settings :polls, :project
  #  # Creates/updates PollsProjectSettings model from polls_settings request 
  #  # params and sets @polls_project_settings instance variable. 
  #  # The div with id="tab-content-polls" is replaced with the rendered 
  #  # partial at views/projects/settings/_polls.rhtml.
  #
  # Returns nothing.
  def update_or_create_settings(module_name, key_name, extra_attrs = {})
    params_name = "#{module_name}_#{key_name}_settings"
    inst_var_name = "@#{params_name}"
    partial_name = "#{key_name.to_s.pluralize}/settings/#{module_name}"
    tab_name = "tab-content-#{module_name}"

    if (inst_var = self.instance_variable_get inst_var_name)
      inst_var.update_attributes(params[params_name.to_sym])
    else
      attrs = params[params_name.to_sym].dup
      inst_var = params_name.camelize.constantize.new(attrs.merge(extra_attrs))
      inst_var.save
      self.instance_variable_set inst_var_name, inst_var
    end
    render(:update) do |page|
      page.replace_html tab_name, :partial => partial_name
    end
  end

  def update_or_create_project_settings(module_name, extra_attrs = {})
    attrs = {:project => @project}.merge(extra_attrs)
    update_or_create_settings(module_name, :project, attrs)
  end

  def update_or_create_user_settings(module_name, extra_attrs = {})
    attrs = {:user => @user}.merge(extra_attrs)
    update_or_create_settings(module_name, :user, attrs)
  end

  def project_settings
    update_or_create_project_settings params[:controller].to_sym
  end

  def user_settings
    update_or_create_user_settings params[:controller].to_sym
  end
end