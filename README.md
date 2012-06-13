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

## Installation

Add this line to your application's Gemfile:

    gem 'syma'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install syma

## Overview

![Syma overview image](https://github.com/boymaas/syma/raw/master/gfx/syma-overview.jpg)

## Framework integration
                      
![Syma overview image](https://github.com/boymaas/syma/raw/master/gfx/syma-rspec-cucumber-riot-integration.jpg)

## Configuration

    capybara_session = Capybara::Session.new(:rack_test, SinatraApp::Simple)
    session_driver = Syma::SessionDriver::Capybara.new(capybara_session)

    Syma.configure do |c|
      c.ui_driver_class      AppSpecificUiDriver
      c.given_driver_class   AppSpecificGivenDriver
      c.session_driver_instance SessionDriver
    end  

For an example configuration on a sinatra app see: `spec/lib/sinatra_app/syma_config_spec.rb` 
and `spec/lib/sinatra_app/simple_spec.rb`.

### AppSpecificUiDriver

Sets up the ui structure of your application. As can be seen in the example
application `lib/sinatra_app/syma_config.rb`. UiDriver defines the ui\_components
of your application. (Instances of Syma::UiComponent) which will drive the ui through
the configured Syma::Session::Driver.

    class UIDriver < Syma::UIDriver
      ui_component :sign_in_screen, SignInScreen
      ui_component :widget_screen, WidgetScreen

      def sign_in(name)
        go_to sign_in_screen
        sign_in_screen.sign_in(mental_model.users[name])
      end
    end

#### UiComponent

Defines a screen, this is an example of a simple login form.
This UiComponent also provides a function sign\_in.

    class SignInScreen < Syma::UIComponent
      component_path '/session/new'
      component_selector '#sign_in_screen'

      def_text_field      :email, :selector => 'input#email'
      def_password_field  :password, :selector => 'input#password'
      def_submitter       :press_sign_in, :selector => 'button'

      def sign_in(user_data)
        email    user_data[:email]
        password user_data[:password]
        press_sign_in
      end
    end

To actually sign an existing user you would do this inside an rspec test, or
cucumber step:

    ui.navigate_to ui.sign_in_screen
    ui.sign_in_screen.sign_in(:email => 'bob@example.com', :password => 'password')

### AppSpecific GivenDriver

Given driver can be used to setup default contexts. As can be seen in the example
application `lib/sinatra_app/syma_config.rb`.

    class GivenDriver < Syma::GivenDriver
      def a_user(name)
        user = {:email => 'bob@example.com', :password => '12345'}
        result = SinatraApp::Simple.create_user(user)
        mental_model.users[name] = result
      end

      def a_widget(name, attributes = {})
        widget = {:name => 'Foo'}.merge(attributes)
        result = SinatraApp::Simple.create_widget(widget)
        mental_model.widgets[name] = result
      end
    end

Ofter you will want to store information into the mental model. So as to compare UI output with
the expected "mental model".

### SessionDriver

The Component which drives the UIComponents. UiComponents have direct access to the methods
defined in `lib/syma/session_driver/capybara/interface.rb`.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
