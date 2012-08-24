class PluginSettingsController < ApplicationController
  unloadable

  def update
    Rails.logger.info "REQUEST: #{request.inspect}"
    Rails.logger.info "PARAMS: #{params.inspect}"
    # render(:update) do |page|
    #   page.replace_html tab_name, :partial => partial_name
    # end
  end
end
