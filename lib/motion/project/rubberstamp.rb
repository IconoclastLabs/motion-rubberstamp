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
    # There's probably a better way to get this info, I'm not terribly familiar with Ruby's filesystem libs

    # Resolve icon's full path
    pwd = Pathname.pwd
    filename = "#{pwd.realdirpath.to_s}/#{icon_name}"

    if File.exist? filename
      width= `identify -format '%w' #{filename}`.to_i
      new_filename = filename.gsub('_base', '')
      status = `convert -background '#0008' -fill white -gravity center -size #{width}x30\
                -stroke black caption:"#{caption}"\
                #{filename} +swap -gravity south -composite #{new_filename}`
    else
      puts "File does not exist, you broke it."
    end
  end

  def installed?
    icons =  Dir.glob('resources/Icon*')
    prexisting_base_icons = icons.map{|icon| icon.include?("base") }
    prexisting_base_icons.include?(true)
  end

  # stub to check if the app needs to be restamped or not.
  def updated?
    true
  end

  # delete old app!
  def wipe
    app = App.config.app_bundle('iPhoneSimulator')
    target = ENV['target'] || App.config.sdk_version
    sim_apps = File.expand_path("~/Library/Application Support/iPhone Simulator/#{target}/Applications")
    Dir.glob("#{sim_apps}/**/*.app").each do |app_bundle|
      if File.basename(app_bundle) == File.basename(app)
        p "Deleting #{app_bundle}"
        rm_rf File.dirname(app_bundle)
        break
      end
    end
  end

  task :run do

    if updated?
      # Clean old out the simulator
      Rake::Task["rubberstamp:sim_clean"].execute
      # Automatically run install on first run
      Rake::Task["rubberstamp:install"].execute unless installed?

      # piggyback on RubyMotion's own app config tool
      project_config_vars = Motion::Project::App.config.variables
      app_version = project_config_vars['version']
      # execute shell commands to get git info
      git_commit  = `git rev-parse --short HEAD`
      git_branch  = `git rev-parse --abbrev-ref HEAD`

      caption = "v#{app_version} #{git_commit} #{git_branch}"
      # process_icon("Icon_base.png", caption)
      # process_icon("Icon@2x_base.png", caption)
      # process_icon("Icon-72_base.png", caption)
      # process_icon("Icon-72@2x_base.png", caption)
      App.info "motion-rubberstamp", "Rubberstamping icons..."
      Dir.glob('resources/*_base.png').each do |icon|
        process_icon(icon, caption)
      end

    else
      App.info "motion-rubberstamp", "No change detected"
    end

    #p NSBundle.mainBundle.resourcePath
  end

  desc "Copy your current app icons to `_base` equivalent backups."
  task :install do
    App.info "motion-rubberstamp", "First Run Installing: Copying original icons"
    if installed?
      raise("Error: It appears that motion-rubberstamp is already installed.")
    else
      Dir.glob('resources/Icon*').each do |icon|
        FileUtils.cp(icon, icon.gsub('.png', '_base.png'), :verbose => true)
      end
    end
  end

  desc "Reverts your icons to their original versions."
  task :revert do
    App.info "motion-rubberstamp", "Reverting icons to their original versions."
    icons = Dir.glob('resources/Icon*_base.png')
    icons.each do |icon|
      FileUtils.cp(icon, icon.gsub('_base.png', '.png'), :verbose => true)
      p "Restored  #{icon.gsub('_base.png', '.png')})"
    end
  end

  desc "Deletes app and kills the simulator (for cache reasons)"
  task :sim_clean do
    App.info "motion-rubberstamp", "Deleting App from simulator for new icons."
    wipe
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
