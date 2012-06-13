# Syma

Syma is a minimal implementation of the WindowDriver pattern as described on
(Martin Fowlers domain)[http://martinfowler.com/eaaDev/WindowDriver.html]

The article starts with a simple description:

    A user interface window acts as an important gateway to a system. Despite the
    fact that it runs on a computer, it often isn't really very computer friendly -
    in particular it's often difficult to program it to carry out tasks
    automatically. This is particularly a problem for testing where automated tests
    do a great deal to simplify the whole development process.

    Window Driver is an programmatic API for a UI window. A Window Driver should
    allow programs to control all dynamic aspects of a window, invoking any action
    and retrieving any information that's available to a human user.

Looking around for other implementations of this pattern I found
[Kookaburra](https://github.com/jwilger/kookaburra) which inspired this project.

## Overview

![Syma overview image](https://github.com/boymaas/syma/gfx/syma-overview.jpg)

## Configuration

    capybara_session = Capybara::Session.new(:rack_test, SinatraApp::Simple)
    session_driver = Syma::SessionDriver::Capybara.new(capybara_session)

    Syma.configure do |c|
      c.ui_driver_class      AppSpecificUiDriver
      c.given_driver_class   AppSpecificGivenDriver
      c.session_driver_instance SessionDriver
    end  

For an example configuration on a sinatra app see: `spec/lib/sinatra_app/syma_config_spec.rb' 
and `spec/lib/sinatra_app/simple_spec.rb'


## Installation

Add this line to your application's Gemfile:

    gem 'syma'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install syma

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
