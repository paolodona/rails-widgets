# Install hook code here
def copy_image(name)
  plugin_images = File.join(File.dirname(__FILE__), 'images')
  app_images = File.join(RAILS_ROOT, 'public/images/widgets')
  from = File.expand_path(File.join(plugin_images,name))
  to = File.expand_path(File.join(app_images,name))
  puts "copy #{from} to #{to}"
end

copy_image 'tooltip_arrow.gif'

