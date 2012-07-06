def copy(file_name, from_dir, to_dir)
  FileUtils.mkdir to_dir unless File.exist?(File.expand_path(to_dir))   
  from = File.expand_path(File.join(from_dir,file_name))
  to = File.expand_path(File.join(to_dir, file_name))
  puts "  creating: #{to}"
  FileUtils.cp from, to unless File.exist?(to)
end

def copy_image(file_name)
  plugin_images = File.join(File.dirname(__FILE__), '..', 'images')
  app_images = File.join(RAILS_ROOT, 'public/images/widgets')
  copy file_name, plugin_images, app_images 
end

def copy_javascript(file_name)
  plugin_javascripts = File.join(File.dirname(__FILE__), '..', 'javascripts')
  app_javascripts = File.join(RAILS_ROOT, 'public/javascripts/widgets')
  copy file_name, plugin_javascripts, app_javascripts 
end

desc "Copies the widgets assets (images and javascripts) to the public folder"
namespace :widgets do
  task :setup do
    copy_image      'tooltip_arrow.gif'
    copy_image      'tooltip_image.gif'
    copy_javascript 'tooltip.js'
  end
end
