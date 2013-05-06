# Motion-Rubberstamp

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

Add this line to your application's Gemfile:

    gem 'motion-rubberstamp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install motion-rubberstamp

This gem relies on imagemagick and ghostscript, which
can easily be installed via [Homebrew](http://mxcl.github.io/homebrew/):

    $ brew install imagemagick

    $ brew install ghostscript

## Usage

motion-rubberstamp adds itself to the build process, so whenever you run `rake` or `rake device` it will 
automatically invoke `rake rubberstamp:run` beforehand. When you run `rake archive` or `rake archive:distribution`,
motion-rubberstamp will automatically invoke `rake rubberstamp:revert`. This means that development builds
will automatically receive overlays and release builds will use your original icons.

Alternatively, you can manually invoke motion-rubberstamp. First use the provided rake task to rename your
Icon files (where * is @2x, -568h etc.) to Icon_base, e.g. Icon@2x_base.png. This rake task automates it 
for you if your icons already exist:

    $ rake rubberstamp:install

Then run the rake task to apply the overlay to your icons:

    $ rake rubberstamp:run

Now when you next build your project, build information will be overlayed
as part of your icon.

To remove the overlays and restore your original icons, you can run

    $ rake rubberstamp:revert

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
