require 'pathname'
require 'fileutils'

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

  def installed?
    icons =  Dir.glob('resources/Icon*')
    prexisting_base_icons = icons.map{|icon| icon.include?("base") }
    prexisting_base_icons.include?(true)
  end

  task :run do
    # Automatically run install on first run
    Rake::Task["rubberstamp:install"].execute unless installed?

    # piggyback on RubyMotion's own app config tool
    project_config_vars = Motion::Project::App.config.variables
    app_version = project_config_vars['version']
    # execute shell commands to get git info
    git_commit  = `git rev-parse --short HEAD`
    git_branch  = `git rev-parse --abbrev-ref HEAD`

    caption = "v#{app_version} #{git_commit.strip} #{git_branch.strip}"
    App.info "motion-rubberstamp", "Rubberstamping icons..."
    Dir.glob('resources/*_base.png').each do |icon|
      process_icon(icon, caption)
    end
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

end

# Make rubberstamp run before any build
task 'build:simulator' => 'rubberstamp:run'
task 'build:device' => 'rubberstamp:run'

# Revert rubberstamp before any archive build
task 'archive' => 'rubberstamp:revert'
task 'archive:distribution' => 'rubberstamp:revert'
