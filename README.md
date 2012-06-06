Overview
========

This plugin makes it easier for your plugin to provide a settings pane for
project or user settings. It makes a few assumptions currently:

* You are setting up a project module in your `init.rb`.

* You have a controller named after your project modules, or 
  don't mind creating one.


Integration
===========

Clone/download the plugin into `vendors/plugins/chiliproject_plugin_settings`.

Add the following to your plugin's `init.rb`, using `example` as an example 
project module name: 

```ruby
Redmine::Plugin.register :my_example_plugin do
  name 'An example plugin'
  ...


  project_module :example do
    permission :view_example, {:example => [:index, :show]}

    # Add a permission for the project settings
    permission :manage_example, {:example => :project_settings}
  end
end

require "dispatcher"
Dispatcher.to_prepare :my_example_plugin do

  require_dependency "chiliproject_plugin_settings"

  # Register the example module with the settings plugin for projects only
  ChiliprojectPluginSettings.register :example, :project

  # To enable for both project and user settings:
  # ChiliprojectPluginSettings.register :example, [:project, :user]
end
```

In your project module's controller (`ExampleController` in this example), 
add the following:

```ruby
class ExampleController < ApplicationController

  # Be sure to exclude any before_filters:
  # before_filter :find_project, :exclude => [:project_settings, :user_settings]

  # Include the settings plugin actions and helpers
  include ChiliprojectPluginSettingsHelper
end
```

Add a model named for the module and settings type (`Project` or `User`):

```ruby
class ExampleProjectSettings < ActiveRecord::Base
  belongs_to :project
  validates_presence_of :project, :name, :content
end
```

Add a migration for your new model:

```ruby
class CreateExampleProjectSettings < ActiveRecord::Migration
  def self.up
    create_table :example_project_settings do |t|
      t.column :project_id, :integer, :null => false
      t.column :name, :string, :limit => 100, :null => false
      t.column :content, :string, :limit => 100, :null => false
    end
    add_index :example_project_settings, :project_id, :name => :example_project_settings_project_id
  end

  def self.down
    drop_table :example_project_settings
  end
end
```

Create a form view template named after your project module 
(`app/views/projects/settings/_example.rhtml` in this example):

```rhtml
<% remote_form_for :example_project_settings, ExampleProjectSettings.find_by_project_id(@project.id),
                   :url => { :controller => 'example', :action => 'project_settings', :id => @project },
                   :builder => TabularFormBuilder,
                   :lang => current_language do |f| %>

<%= error_messages_for 'example_project_settings' %>

<div class="box tabular">
  <p>
    <%= f.text_field :name, :required => true %>
  </p>
  <p>
    <%= f.text_field :content, :required => true %>
  </p>
</div>

<%= submit_tag(l(:button_save)) %>

<% end %>
```
