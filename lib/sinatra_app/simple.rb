require 'capybara'

# These are required for the Rack app used for testing
require 'sinatra/base'
require 'json'

module SinatraApp
  class Simple < Sinatra::Base
    enable :sessions
    disable :show_exceptions

    # Define state of SimpleApp

    def self.clear
      @@users = {}
      @@widgets = []
    end

    def self.create_user(user_data)
      @@users ||= {}
      @@users[user_data.fetch(:email)] = user_data
    end

    def self.create_widget( widget_data )
      @@widgets ||= []
      widget_data[:id] = `uuidgen`.strip
      @@widgets << widget_data
      widget_data
    end

    def self.widgets
      @@widgets ||= []
    end

    def self.users 
      @@users ||= {}
    end

    def widgets
      self.class.widgets
    end

    def users 
      self.class.users
    end

    # Markup helpers

    def markaby &block
      Markaby::Builder.new(&block).to_s
    end

    # Sinatra actions

    post '/session' do
      email    = params.fetch('email', :NoEmail)
      password = params.fetch('password', :NoPassword)
      user = users.fetch(email, false)

      if user && user.fetch(:password) == password
        session[:logged_in] = true
        status 200
        body 'You are logged in!'
      else
        session[:logged_in] = false
        status 403
        body 'Log in failed!'
      end
    end

    get '/session/new' do
      haml <<-EOS.gsub(/^\s{8}/,'')
        %html
          %head
            %title Sign In
          %body
            %div#sign_in_screen
              %form{:action=>'/session', :method=>'POST'}
                %label{:for=>'email'} Email:
                %input.email{:id=>'email', :name=>'email', :type=>'text'}
                %label{:for=>'password'} Password:
                %input.password{:id=>'password', :name=>'password', :type=>'text'}
                %button Sign In
      EOS
    end

    post '/widgets' do
      widget_data = {:name => params.fetch('name')}
      widget_data[:id] = `uuidgen`.strip
      widgets << widget_data
      redirect to('/widgets')
    end

    post '/widgets/:widget_id' do
      widget_id = params.fetch('widget_id')
      widgets.delete_if {|w| w[:id] == widget_id }
      redirect to('/widgets')
    end

    get '/widgets/new' do
      haml <<-EOS.gsub(/^\s{8}/,'')
        %html
          %head
            %title New Widget
          %body
            %div#widget_form
              %form{:action=>'/widgets', :method=>'POST'}
                %label{:for=>'name'} Name:
                %input.name{:id=>'name', :name=>'name', :type=>'text'}
                %button Save
      EOS
    end

    get '/widgets' do
      raise "Not logged in!" unless session.fetch('logged_in', false)

      haml <<-EOS.gsub(/^\s{8}/,''), :locals => {:widgets => widgets}
        %html
          %head
            %title New Widget
          %body
            - if widgets
              %div#widget_list
                %div.last_widget.created
                  %span.id= widgets.last.fetch(:id)
                  %span.name= widgets.last.fetch(:name)
                %ul
                  - widgets.each_with_index do |w,i|
                    %li.widget_summary{:id => "ws_%d" % i}
                      %span.id= w.fetch(:id)
                      %span.name= w.fetch(:name)
                      - action = "/widgets/%s" % w.fetch(:id)
                      - id = "delete_%s" % w.fetch(:id)
                      %form{:action=>action, :method=>'POST', :id=> id}
                        %button Delete
                %a{:href=>'/widgets/new'} New Widget
      EOS
    end

    error do
      e = request.env.fetch('sinatra.error')
      raise e
    end
  end

end

