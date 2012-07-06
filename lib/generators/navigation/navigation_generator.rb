class NavigationGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  
  desc "creates a template file for the named navigation in app/views/widgets/"
  def create_navigation_template
    empty_directory "app/views/widgets"
    template 'navigation.html.erb', "app/views/widgets/_#{file_name}_navigation.html.erb"
  end
  
  protected 
  
  def file_name
    name.underscore
  end
  
end
