# Motion-Rubberstamp

![motion-rubberstamp](https://s3.amazonaws.com/iconoclastweb/github/motion-rubberstamp/logo_200.png "motion-rubberstamp")

This is aimed at being a development tool, it will create an
overlay for your iOS app icon that includes your version, commit
and branch information so you can know exactly what version of
your app is running on your device, or so that beta testers can
easily report which version they are running.

Here's what it does:

Before:
![Before motion-rubberstamp](https://s3.amazonaws.com/iconoclastweb/github/icon_before.png "Before motion-rubberstamp")
After:
![After motion-rubberstamp](https://s3.amazonaws.com/iconoclastweb/github/icon_after.png "After motion-rubberstamp")

## Installation

Add this line to your RubyMotion app's Gemfile:

    gem 'motion-rubberstamp'

And then execute:

    $ bundle

Or install it manually as:

    $ gem install motion-rubberstamp

and add to your RubyMotion app's Rakefile

    require 'motion-rubberstamp'

This gem also relies on imagemagick and ghostscript, which
can easily be installed via [Homebrew](http://mxcl.github.io/homebrew/):

    $ brew install imagemagick

    $ brew install ghostscript

## Usage

Motion-rubberstamp adds itself to the build process, so whenever you run `rake` or `rake device` it will 
automatically invoke `rake rubberstamp:run` beforehand. 

When you run `rake archive` or `rake archive:distribution`, motion-rubberstamp will automatically invoke 
`rake rubberstamp:revert`. This means that development builds will now automatically receive overlays and 
release builds will use your original icons.

You can also manually invoke motion-rubberstamp at any time with:

    $ rake rubberstamp:run

Or to remove the overlays and restore your original icons, you can run

    $ rake rubberstamp:revert

## Notes

The iOS Simulator will appear to cache your app icons when you run a
build because RubyMotion's deployer apparently only looks for new resource
files when deploying (it copies resource files to a simulator directory on 
your local filesystem). Motion-rubberstamp is still invoked, but it won't 
appear to update on your simulator. Deleting the app on your simulator 
before building will invoke the refresh but is a non-optimal solution. I 
hope to have this solved in the next release.

Motion-rubberstamp also currently only checks for app icons in the `/resources`
path, regardless of what your Rakefile is configured for.
    
## Uninstalling

Motion-rubberstamp duplicates your original icon files with `_base` suffixes. To uninstall, simply remove
motion-rubberstamp from your gemfile

## Contributing

I've probably made the file management more difficult and rigid than it needs to be, and I have no
clue how to write tests for this. But I'll gladly accept any help that's offered.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thanks

Many thanks to Krzysztof Zabłocki and Evan Doll for the idea and
implementation
[details](http://www.merowing.info/2013/03/overlaying-application-version-on-top-of-your-icon/).
