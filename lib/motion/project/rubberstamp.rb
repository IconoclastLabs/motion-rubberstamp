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
    git_commit  = %x['git rev-parse --short HEAD']
    git_branch  = %x['git rev-parse --abbrev-ref HEAD']



  end

end

