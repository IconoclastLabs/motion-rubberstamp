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
  def process_icon(icon_name, caption)
    # Resolve icon's full path
    pwd = Pathname.pwd
    filename = "#{pwd.realdirpath.to_s}/#{icon_name}"

    if File.exist? filename
      width= `identify -format '%w' #{filename}`
      height = (width.to_i * 0.4).to_i
      width = (width.to_i)
      if width >= 57
        new_filename = filename.gsub('_base', '')
        status = `convert -background '#0008' -fill white -gravity center -size #{width.to_i}x#{height} \
                  caption:'#{caption}' \
                  #{filename} +swap -gravity south -composite #{new_filename}`
      end
    else
      App.info "motion-rubberstamp", "File does not exist, you broke it."
    end
  end

  # have we made base icons yet?
  def installed?
    icons =  Dir.glob('resources/Icon*')
    prexisting_base_icons = icons.map{|icon| icon.include?("base") }
    prexisting_base_icons.include?(true)
  end

  # do we have imagemagick?
  def has_imagemagick?
    system("which identify > /dev/null") && system("which convert > /dev/null")
  end

  # check if this app even has icons yet.
  def has_icons?
    Dir.glob('resources/Icon*').size > 0
  end

  def create_caption
    project_config_vars = Motion::Project::App.config.variables
    app_version = project_config_vars['version']
    # execute shell commands to get git info
    git_commit  = `git rev-parse --short HEAD`
    git_branch  = `git rev-parse --abbrev-ref HEAD`
    caption = "v#{app_version} #{git_commit.strip} #{git_branch.strip}"
  end

  # stub to check if the app needs to be restamped or not.
  def updated?(caption)
    previous_caption = `xattr -p com.iconoclastlabs.motion-rubberstamp Rakefile`
    previous_caption.strip!
    if (previous_caption == "") # first run or something is amiss
      return true
    elsif (caption != previous_caption)
      App.info "motion-rubberstamp", "Rubberstamp caption has changed."
      return true
    else
      #App.info "motion-rubberstamp", "No Caption difference detected"
      return false
    end
  end

  # copy over rubberstamp icons to use!
  def deploy_icons
   lib_dir = File.dirname(__FILE__)
    local_icons = File.join(lib_dir, "assets/*")
    App.info "motion-rubberstamp", "Deploying Icons from #{local_icons}"
    Dir.glob(File.join(lib_dir, "assets/*")).each do |icon|
      App.info "motion", icon
      FileUtils.cp(icon, './resources', :verbose => true)
    end
  end

  def missing_resources?
    # sometimes there's no resources folder or icons
    !(File.directory?('./resources') && has_icons?)
  end


  desc "Initializes the app with resources as needed"
  task :init do
    # corner case, sometimes there's no resources folder generated yet
    FileUtils.mkdir('./resources') unless File.directory?('./resources')
    #should we deploy the template icons?
    deploy_icons unless has_icons?    
  end

  desc "Actively stamps the current app icons with captions."
  task :run do

    caption = create_caption

    if updated?(caption)
      App.info "motion-rubberstamp", "Rubberstamping icons..."
      # Let's abuse the fact that we *know* we're on OSX and have xattr available
      # The Rakefile seems like a constant file to store data in:
      attribute = `xattr -w com.iconoclastlabs.motion-rubberstamp "#{caption}" Rakefile`
      # Clean old out the simulator
      Rake::Task["rubberstamp:sim_clean"].execute
      # Automatically run install on first run
      Rake::Task["rubberstamp:install"].execute unless installed?
      # piggyback on RubyMotion's own app config tool
      Dir.glob('resources/*_base.png').each do |icon|
        process_icon(icon, caption)
      end
    end
  end

  desc "Copy your current app icons to `_base` equivalent backups."
  task :install do
    if has_imagemagick?
      App.info "motion-rubberstamp", "First Run Installing: Copying original icons"
      if installed?
        raise("Error: It appears that motion-rubberstamp is already installed.")
      elsif missing_resources?
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
