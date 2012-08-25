Overview
========

This plugin makes it easier for your plugin to provide a settings pane for
project or user settings. It makes a few assumptions currently:

* You are setting up a project module in your `init.rb`.


Integration
===========

Clone/download the plugin into `vendors/plugins/chiliproject_plugin_settings`.

Add the following to your plugin's `init.rb`, using `example` as an example 
project module name: 

```ruby
# vendor/plugins/chiliproject_example/init.rb
Redmine::Plugin.register :chiliproject_example do
  name 'An example plugin'
  # ...

  project_module :example do
    permission :view_example, {:example => [:index, :show]}

    # Add a permission for the project settings.
    permission :manage_example, {:example => :project_settings}
  end

  # Register the project settings for the example module.
  requires_redmine_plugin :chiliproject_plugin_settings, '0.0.1'
  project_settings :example
end
```

Add a model named for the module and settings type (`Project` or `User`):

```ruby
# vendor/plugins/chiliproject_example/app/models/example_project_settings.rb
class ExampleProjectSettings < ActiveRecord::Base
  belongs_to :project
  validates_presence_of :project
end
```

Add a migration for your new model:

```ruby
# vendor/plugins/chiliproject_example/db/migrate/20120825011011_create_example_project_settings.rb
class CreateExampleProjectSettings < ActiveRecord::Migration
  def self.up
    create_table :example_project_settings do |t|
      t.integer :project_id, :null => false
      t.string :name
      t.string :content
    end
    add_index :example_project_settings, :project_id
  end

  def self.down
    drop_table :example_project_settings
  end
end
```

Create a form view template named after your project module 
(`app/views/projects/settings/_example.rhtml` in this example):

```rhtml
<%# vendor/plugins/chiliproject_example/app/views/projects/settings/_example.rhtml %>
<% project_plugin_settings_form_for :example do |f| %>

<%= project_plugin_settings_error_messages_for :example %>

<div class="box tabular">
  <p>
    <%= f.text_field :name %>
  </p>
  <p>
    <%= f.text_field :content %>
  </p>
</div>

<%= submit_tag(l(:button_save)) %>

<% end %>
```
