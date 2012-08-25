# encoding: utf-8

def do_routes(map)
  map.with_options :controller => 'plugin_settings' do |routes|
    routes.with_options :conditions => {:method => :post} do |views|
      views.connect 'plugin_settings/:object_name/:module_name/:object_id', :action => 'update'
    end
  end
end

if defined? map
  do_routes(map)
else
  ActionController::Routing::Routes.draw do |map|
    do_routes(map)
  end
end
