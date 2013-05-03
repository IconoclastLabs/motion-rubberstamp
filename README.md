# Motion::Rubberstamp

This is aimed at being a development tool, it will create an 
overlay for your iOS app icon that include your version and
commit information so you can know exactly what version of 
your app is running on your device.

TODO: insert example icon with before/after

## Installation

Add this line to your application's Gemfile:

    gem 'motion-rubberstamp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install motion-rubberstamp

This gem relies on imagemagick and ghostscript, which
can easily be installed via homebrew:

    $ brew install imagemagick

    $ brew install ghostscript

## Usage

Todo: Write usage info

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thanks

Many thanks to Krzysztof Zabłocki and Evan Doll for the idea and
implementation
[details](http://www.merowing.info/2013/03/overlaying-application-version-on-top-of-your-icon/).
