class RubberstampConfig
  # TODO: make caption customizable
  #attr_accessor :caption
  def initialize
    #@caption ||= self.create_caption
  end

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

end