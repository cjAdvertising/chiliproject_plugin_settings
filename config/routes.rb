RedmineApp::Application.routes.draw do
  match "/plugin_settings/:object_name/:module_name/:object_id" => "plugin_settings#update", via: [:put, :post]
end