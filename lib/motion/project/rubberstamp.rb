Motion::Project::App.setup do |app|
  app.development do
    app.vendor_project File.join(File.dirname(__FILE__),"..",'..','framework'), :static
  end
end

namespace :rubberstamp do
  desc "Stamp iOS app icons with version and git information"

  task :run do

    project_config_vars = Motion::Project::App.config.variables

    app_version = project_config_vars['version']
    # execute shell commands to get git info
    git_commit  = `git rev-parse --short HEAD`
    git_branch  = `git rev-parse --abbrev-ref HEAD`

    caption = "v#{app_version} #{git_commit} #{git_branch}"

  end

end

