require 'pathname'
require 'fileutils'

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
      status = `convert -background '#0008' -fill white -gravity center -size #{width}x40\
                caption:"#{caption}"\
                #{filename} +swap -gravity south -composite #{new_filename}`
    else
      puts "File does not exist, you broke it."
    end
  end

  task :run do
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
    Dir.glob('resources/*_base.png').each do |icon|
      process_icon(icon, caption)
    end
  end

  desc "Copy your current app icons to `_base` equivalent backups."
  task :install do
    icons =  Dir.glob('resources/Icon*')
    icons.each do |icon|
      FileUtils.cp(icon, icon.gsub('.png', '_base.png'), :verbose => true)
    end
  end

end
