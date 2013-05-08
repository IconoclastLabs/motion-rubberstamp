![motion-rubberstamp](https://s3.amazonaws.com/iconoclastweb/github/motion-rubberstamp/quicktour.png "motion-rubberstamp")
#### 1. Just add this gem to your RubyMotion project, and your app icons will get stamped!
App Icon _Before_:
![Before motion-rubberstamp](https://s3.amazonaws.com/iconoclastweb/github/icon_before.png "Before motion-rubberstamp")
App Icon _After:_
![After motion-rubberstamp](https://s3.amazonaws.com/iconoclastweb/github/icon_after.png "After motion-rubberstamp")

#### 2. If you don't have an icon, we will automatically provide one.
![Free Icon](https://s3.amazonaws.com/iconoclastweb/github/free.png "Free Rubberstamp Icon")

#### 3. Removal
This gem will intelligently remove itself for your archive builds, but you can also do it mannually via rake.

    $ rake rubberstamp:revert

#### 4. TADAAA!
This is aimed at being a development tool, it will create an
overlay for your iOS app icon that includes your version, commit
and branch information so you can know exactly what version of
your app is running on your device, or so that beta testers can
easily report which version they are running.

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

The iOS Simulator is trying to cache your app icons.  For this reason we've put in a significant refresh step!
Your app data and simulator are restarted on restamp.  It's a small but notable necessary evil.

Motion-rubberstamp _currently_ only checks for app icons in the `/resources`
path, regardless of what your Rakefile is configured for.
    
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
