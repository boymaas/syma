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
                  %p.hello Hello World
                  %ul
                    %li First Item
                    %li Second Item
                %form.a_form{:action=>'/form_post', :method=>'post'}
                  %input.a_text_input{:type => :text, :value => :value_of_a_text_input}
                  %button.a_submit_button{:value => 'Submit'}

          eohaml
        end
        get '/hello' do
          'Hello World!'
        end
        post '/form_post' do
          'form_has_been_posted'
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

      context "#each_element_matching" do
        before { subject.navigate_to('/') }
        context "element exists in dom" do
          let(:elements) { subject.each_element_matching('ul li') {|id| id} }
          it "returns all elements" do 
            elements.count.should == 2
          end
          it "returns the correct elements" do
            elements.map(&:tag_name).should == ['li', 'li']
          end
        end
        context "element does not exists" do
            it "raises the correct error" do
              expect {
                subject.each_element_matching('.non_existing_element') do |el|
                  :can_ignore_return_value
                end
              }.to raise_error(ElementNotFound)
            end
        end
      end

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
      context "finders" do
        before { subject.navigate_to('/') }

        context "#find_text" do
          context "element exists" do
            it "finds the text" do
              subject.find_text('.hello').should == "Hello World"
            end
          end
          context "element does not exists" do
            it "raises the correct error" do
              expect {
                subject.find_text('.non_existing_element')
              }.to raise_error(ElementNotFound)
            end
          end
        end
        context "#find_form_field" do
          context "input_field exists" do
            let(:a_text_input) { subject.find_form_field('form .a_text_input') }
            it "is the correct type" do
              a_text_input.should be_an(Capybara::InputField) 
            end
            it "can fetch the value" do
              a_text_input.get_value.should == 'value_of_a_text_input'
            end
          end
          context "element does not exists" do
            it "raises the correct error" do
              expect {
                subject.find_form_field('.non_existing_element')
              }.to raise_error(ElementNotFound)
            end
          end
        end
      end
      context "#click_on" do
        before { subject.navigate_to('/') }
        context "button exists" do
          it "performs the action" do
            subject.click_on('form .a_submit_button')
            subject.caps.tap do |session|
              session.current_path.should == '/form_post'
              session.status_code.should == 200
              session.body.should include "form_has_been_posted"
            end
          end
        end
        context "element does not exists" do
          it "raises the correct error" do
            expect {
              subject.click_on('.non_existing_element')
            }.to raise_error(ElementNotFound)
          end
        end
      end
    end

    describe Capybara::InputField do
      let(:selector) { stub(:selector) }
      let(:capy_session) {stub(:capy_session)}
      context "#initialize" do
        it "takes a session and a selector"  do
          described_class.new(capy_session)
        end
      end
    end
  end
end
