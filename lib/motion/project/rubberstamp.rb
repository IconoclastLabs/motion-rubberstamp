require 'pathname'

Motion::Project::App.setup do |app|
  app.development do
    app.vendor_project File.join(File.dirname(__FILE__),"..",'..','framework'), :static
  end
end

namespace :rubberstamp do
  desc "Stamp iOS app icons with version and git information"
  def process_icon(icon_name, caption)
    # There's probably a better way to get this info, I'm not terribly familiar with Ruby's filesystem libs
    pwd = Pathname.pwd
    filename = "#{pwd.realdirpath.to_s}/resources/#{icon_name}"

    if File.exist? filename
      width= `identify -format '%w' #{filename}`.to_i
      new_filename = filename.gsub('_base', '')
      status = `convert -background '#0008' -fill white -gravity center -size #{width}x40\
                caption:"#{caption}"\
                #{filename} +swap -gravity south -composite #{new_filename}`
      p status
    else
      puts "File does not exist"
    end 
  end

  task :run do
    project_config_vars = Motion::Project::App.config.variables

    app_version = project_config_vars['version']
    # execute shell commands to get git info
    git_commit  = `git rev-parse --short HEAD`
    git_branch  = `git rev-parse --abbrev-ref HEAD`

    caption = "v#{app_version} #{git_commit} #{git_branch}"
    process_icon("Icon_base.png", caption)
    process_icon("Icon@2x_base.png", caption)
    process_icon("Icon-72_base.png", caption)
    process_icon("Icon-72@2x_base.png", caption)
  end

  desc "Copy your current app icons to _base backups, or install a default set if you don't have icons yet."
  task :install do
    p Dir.glob('resources/Icon*')
  end

end
