namespace :jw_player do
  
  PLUGIN_ROOT = File.dirname(__FILE__) + '/../'
  
  desc 'Installs required swf & javascript files to the public/javascripts directory.'
  task :install do
    puts 'installing player.swf to ' << RAILS_ROOT << '/public/swf'
    FileUtils.cp_r Dir[PLUGIN_ROOT + '/assets/swf'], RAILS_ROOT + '/public'
    puts 'installing swwobjects.js to ' << RAILS_ROOT << '/public/javascripts'
    FileUtils.cp Dir[PLUGIN_ROOT + '/assets/javascripts/*.js'], RAILS_ROOT + '/public/javascripts'
  end

  desc 'Removes the swf & javascripts for the plugin.'
  task :remove do
    puts 'removing player.swf' 
    FileUtils.rmtree %{swf}.collect { |f| RAILS_ROOT + "/public/" + f } 
    puts 'removing swfobjects.js'
    FileUtils.rm %{swfobjects.js}.collect { |f| RAILS_ROOT + "/public/javascripts/" + f  }
  end
  
end
