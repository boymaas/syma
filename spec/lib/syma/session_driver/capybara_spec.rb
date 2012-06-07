require 'capybara'
require 'haml'
require 'sinatra/base'

require 'syma/session_driver/capybara'


class Syma
  module SessionDriver
    describe Capybara do

      class TestApp < Sinatra::Base
        get '/' do
          haml <<-eohaml.gsub(/^\s{12}/,'')
            %html
              %head
                %title TestApp
              %body
                #container
                  %p Hello World
                  %ul
                    %li First Item
                    %li Second Item
          eohaml
        end
        get '/hello' do
          'Hello World!'
        end
        error do
          e = request.env.fetch('sinatra.error')
          raise e
        end
      end


      let(:capy_session)  do
        ::Capybara::Session.new(:rack_test, TestApp)
      end

      subject { described_class.new(capy_session) }

      specify { subject.should be_an(Syma::SessionDriver::Capybara)}
          
      context "#navigate_to" do
        it "navigates to the home page" do
          subject.navigate_to('/')
          subject.caps.tap do |session|
            session.current_path.should == '/'
            session.status_code.should == 200
          end
        end
        it "it navigates to the /hello" do
          subject.navigate_to('/hello')
          subject.caps.tap do |session|
            session.current_path.should == '/hello'
            session.status_code.should == 200
            session.body.should include "Hello World!"
          end
        end
      end
      context "#find_text" do
      end
      context "#find_input_field" do
      end
      context "#click_on" do
      end
    end
    describe Capybara::InputField do
      let(:selector) { stub(:selector) }
      let(:capy_session) {stub(:capy_session)}
      context "#initialize" do
        it "takes a session and a selector"  do
          described_class.new(capy_session, selector)
        end
      end
    end
  end
end
