require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'fileutils'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the flash_player plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Flash MP3/Media/Image/FLV Player'
  rdoc.options << '--line-numbers' << '--inline-source' << '--accessor=cattr_accessor'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Updates application with the flash movies (SWFs) and javascripts for the plugin.'
task :update_assets => :download_assets do
  FileUtils.cp_r Dir['assets/swf'], '../../../public'
  FileUtils.cp Dir['assets/javascripts/*.js'], '../../../public/javascripts'
end

desc 'Downloads latest flash movies (SWFs) from jeroenwijering.com'
task :download_assets do
  FileUtils.mkdir 'tmp'
  begin
    FileUtils.cd 'tmp' do
      { 
	:flv_player    =>  'flvplayer.swf',  
	:mp3_player    =>  'mp3player.swf',
	:image_rotator =>  'imagerotator.swf',
	:media_player  =>  'mediaplayer.swf' 
      }.each do |player_type, file|
        `wget http://www.jeroenwijering.com/upload/jw_#{player_type}.zip`
	`unzip jw_#{player_type}.zip`
	FileUtils.cp "jw_#{player_type}/#{file}", '../assets/swf/'
	puts "------ Successfully downloaded latest #{player_type} -----"
      end
    end
  ensure
    FileUtils.rm_rf 'tmp'
  end
end

desc 'Removes the flash movies (SWFs) and javascripts for the plugin.'
task :remove_assets do
  FileUtils.rm %{ufo.js}.collect { |f| "../../../public/javascripts/" + f  }  #files to rm
  FileUtils.rmtree %{swf}.collect { |f| "../../../public/" + f } #trees to rm
end
