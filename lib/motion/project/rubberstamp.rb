require 'pathname'
require 'fileutils'
require 'motion/project/app'
require 'motion/project/config'


# Gratuitously lifted from Laurent Sansonetti's motion-testflight.
unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end



namespace :rubberstamp do
  desc "Stamp iOS app icons with version and git information"


  desc "Initializes the app with resources as needed"
  task :init do
    rubberstamp = RubberstampConfig.new
    # corner case, sometimes there's no resources folder generated yet
    FileUtils.mkdir('./resources') unless File.directory?('./resources')
    #should we deploy the template icons?
    rubberstamp.deploy_icons unless rubberstamp.has_icons?    
  end

  desc "Actively stamps the current app icons with captions."
  task :run do
    rubberstamp = RubberstampConfig.new
    caption = rubberstamp.create_caption
    # TODO: Add a config point option to the rakefile for custom captions
    # or toggling on/off version or git information?
    if rubberstamp.updated?(caption)
      App.info "motion-rubberstamp", "Rubberstamping icons..."
      # Clean old out the simulator
      Rake::Task["rubberstamp:sim_clean"].execute
      # Automatically run install on first run
      Rake::Task["rubberstamp:install"].execute unless installed?
      # Let's abuse the fact that we *know* we're on OSX and have xattr available
      # The Rakefile seems like a constant file to store data in:
      attribute = `xattr -w com.iconoclastlabs.motion-rubberstamp "#{caption}" Rakefile`
      # piggyback on RubyMotion's own app config tool
      Dir.glob('resources/*_base.png').each do |icon|
        rubberstamp.process_icon(icon, caption)
      end
    end
  end

  desc "Copy your current app icons to `_base` equivalent backups."
  task :install do
    if rubberstamp.has_imagemagick?
      App.info "motion-rubberstamp", "First Run Installing: Copying original icons"
      if rubberstamp.installed?
        raise("Error: It appears that motion-rubberstamp is already installed.")
      elsif rubberstamp.missing_resources?
        raise("Error: You are missing essential resources for stamping.  Try 'rake rubberstamp:init' to deploy canned resources.")
      else
        Dir.glob('resources/Icon*').each do |icon|
          FileUtils.cp(icon, icon.gsub('.png', '_base.png'), :verbose => true)
        end
      end
    else
      raise("Error: Cannot find ImageMagick commands.  Please install ImageMagick to proceed.")
    end
  end

  desc "Reverts your icons to their original versions."
  task :revert do
    App.info "motion-rubberstamp", "Reverting icons to their original versions."
    icons = Dir.glob('resources/Icon*_base.png')
    icons.each do |icon|
      FileUtils.mv(icon, icon.gsub('_base.png', '.png'), :verbose => true)
    end
    # hollow out the caption xattr
    attribute = `xattr -w com.iconoclastlabs.motion-rubberstamp "" Rakefile`
  end

  desc "Deletes app and kills the simulator (for cache reasons)"
  task :sim_clean do
    App.info "motion-rubberstamp", "Closing simulator to clear cached icons"
    scripts_dir = File.join(File.dirname(__FILE__), "scripts")
    close_script = File.expand_path(File.join(scripts_dir, "close_simulator.applescript"))

    system("osascript #{close_script}")
  end

end

# Make rubberstamp run before any build
task 'build:simulator' => 'rubberstamp:run'
task 'build:device' => 'rubberstamp:run'

# Revert rubberstamp before any archive build
task 'archive' => 'rubberstamp:revert'
task 'archive:distribution' => 'rubberstamp:revert'
