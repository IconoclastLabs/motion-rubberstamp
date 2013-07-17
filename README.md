![motion-rubberstamp](https://s3.amazonaws.com/iconoclastweb/github/motion-rubberstamp/quicktour.png "motion-rubberstamp")
#### 1. Just add this gem to your RubyMotion project, and your app icons will get stamped!
App Icon _Before_:
![Before motion-rubberstamp](https://s3.amazonaws.com/iconoclastweb/github/icon_before.png "Before motion-rubberstamp")
App Icon _After:_
![After motion-rubberstamp](https://s3.amazonaws.com/iconoclastweb/github/icon_after.png "After motion-rubberstamp")

#### 2. If you don't have an icon we can provide one to start.
Simply run the init rake task, and we'll copy a canned placeholder over.

    $ rake rubberstamp:init
    
![Free Icon](https://s3.amazonaws.com/iconoclastweb/github/free.png "Free Rubberstamp Icon")

#### 3. Removal
This gem will intelligently omit itself from your archive builds, but you can also do it manually via rake.

    $ rake rubberstamp:revert

#### 4. TADAAA!
This is aimed at being a development tool, it will create an
overlay for your iOS app icon that includes your version, commit
and branch information so you can know exactly what version of
your app is running on your device, or so that beta testers can
easily report which version they are running. If your icons don't
need to be updated, the motion-rubberstamp won't do anything.

## Installation

### Gemfile Install
Add this line to your RubyMotion app's [Gemfile](http://gembundler.com/v1.3/rubymotion.html):

    gem 'motion-rubberstamp'

And then execute:

    $ bundle

### Manual Install
Or install it manually as:

    $ gem install motion-rubberstamp

and add to your RubyMotion app's Rakefile

    require 'motion-rubberstamp'

### Dependencies
This gem also relies on imagemagick and ghostscript, which
can easily be installed via [Homebrew](http://mxcl.github.io/homebrew/):

    $ brew install imagemagick

    $ brew install ghostscript

## Usage

#### Installing the Gem is all that's needed to get started.
Motion-rubberstamp adds itself to the build process, so whenever you run `rake` or `rake device` it will
automatically invoke `rake rubberstamp:run` beforehand.

_Smart Cleanup:_ When you run `rake archive` or `rake archive:distribution`, motion-rubberstamp will automatically invoke
`rake rubberstamp:revert`. This means that development builds will now automatically receive overlays and
release builds will use your original icons.

## Rake Tasks

You can also manually invoke motion-rubberstamp at any time with:

    $ rake rubberstamp:run

Or to remove the overlays and restore your original icons, you can run

    $ rake rubberstamp:revert

## Notes

_Dealing with cache:_ 
The iOS Simulator is trying to cache your app icons. For this reason we've put in a significant step that
will refresh your simulator automatically by closing the simulator to force the icon to refresh.  We've put
in a process to detect changes and minimize the amount of icon re-rendering and simulator restarting is 
required, but it's a notable necessary evil to ensure the icons are always current.

_Checking resources:_
Motion-rubberstamp _currently_ only checks for app icons in the `/resources`
path, regardless of what your Rakefile is configured for.

_Smart Stamps:_
Motion-rubberstamp will only run if your version or git information has changed to prevent invoking
ImageMagick and pals more than necessary.

_Add to .gitignore:_
It is *highly recommended*, that once you have rubberstamped your Icon and added the base files to the repo, that you 
add your stamped icon files to your `.gitignore` that is:
```
resources/Icon-72.png
resources/Icon-72@2x.png
resources/Icon-Small-50@2x.png
resources/Icon-Small@2x.png
resources/Icon.png
resources/Icon@2x.png
```
This will stop git from asking you to commit silly stamps, and avoid binary merge conflicts with anyone else who might be
working on the project.  If you like to commit a lot and you're the only one working on the project then by all means 
have fun and igore this message :+1:

## Uninstall
#### Bye?
Rubberstamp will not stamp your archive/production apps.  No need to leave us like that!  But if you must...

To uninstall, simply run `rake rubberstamp:revert` to restore your original icons, then
delete motion-rubberstamp from your gemfile or rakefile.

#### Changing Icons?
If you have our starter icon, or you've changed your mind on your icon it's easy to switch!
Run `rake rubberstamp:revert` and then copy in your new icons to your resource folder.

## Contributing

I've probably made the file management more difficult and rigid than it needs to be, and I have no
clue how to write tests for this. But I'll gladly accept any help that's offered.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thanks

As brought to our attention, this was also done by [Clay's Allsopp!](https://github.com/clayallsopp/motion-smarticons), in a most
elegant solution!  We're hoping to continue progressing this gem to make sure it is useful and provides a wide array of
utility regardless :)

Many thanks to Krzysztof Zabłocki and Evan Doll for the idea and
implementation
[details](http://www.merowing.info/2013/03/overlaying-application-version-on-top-of-your-icon/).
