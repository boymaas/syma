require 'capybara'

# These are required for the Rack app used for testing
require 'sinatra/base'
require 'json'

module SinatraApp
  class Simple < Sinatra::Base
    enable :sessions
    disable :show_exceptions

    def self.clear
      @@users = {}
      @@widgets = []
    end

    def self.create_user(user_data)
      @@users ||= {}
      @@users[user_data[:email]] = user_data
    end

    def self.create_widget( widget_data )
      @@widgets ||= []
      widget_data[:id] = `uuidgen`.strip
      @@widgets << widget_data
      @@last_widget_created = widget_data
    end

    post '/session' do
      user = @@users[params[:email]]
      if user && user[:password] == params[:password]
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
      body <<-EOF
          <html>
            <head>
              <title>Sign In</title>
            </head>
            <body>
              <div id="sign_in_screen">
                <form action="/session" method="POST">
                  <label for="email">Email:</label>
                  <input id="email" name="email" type="text" />

                  <label for="password">Password:</label>
                  <input id="password" name="password" type="password" />

                  <input type="submit" value="Sign In" />
                </form>
              </div>
            </body>
          </html>
      EOF
    end

    post '/widgets' do
      @@widgets ||= []
      widget_data = if request.media_type == 'application/json'
                      parse_json_req_body
                    else
                      {:name => params['name']}
                    end
      widget_data[:id] = `uuidgen`.strip
      @@widgets << widget_data
      @@last_widget_created = widget_data
      if request.accept? 'text/html'
        redirect to('/widgets')
      elsif request.accept? 'application/json'
        status 201
        headers 'Content-Type' => 'application/json'
        body widget_data.to_json
      else
        redirect to('/widgets')
      end
    end

    post '/widgets/:widget_id' do
      @@widgets.delete_if do |w|
        w[:id] == params['widget_id']
      end
      redirect to('/widgets')
    end

    get '/widgets/new' do
      body <<-EOF
            <html>
              <head>
                <title>New Widget</title>
              </head>
              <body>
                <div id="widget_form">
                  <form action="/widgets" method="POST">
                    <label for="name">Name:</label>
                    <input id="name" name="name" type="text" />

                    <input type="submit" value="Save" />
                  </form>
                </div>
              </body>
            </html>
      EOF
    end


    get '/widgets' do
      raise "Not logged in!" unless session[:logged_in]
      @@widgets ||= []
      last_widget_created, @@last_widget_created = @@last_widget_created, nil
      content = ''
      content << <<-EOF
          <html>
            <head>
              <title>Widgets</title>
            </head>
            <body>
              <div id="widget_list">
      EOF
      if last_widget_created
        content << <<-EOF
                  <div class="last_widget created">
                    <span class="id">#{last_widget_created[:id]}</span>
                    <span class="name">#{last_widget_created[:name]}</span>
                  </div>
        EOF
      end
      content << <<-EOF
                <ul>
      EOF
      @@widgets.each_with_index do |w,i|
        content << <<-EOF
                  <li class="widget_summary" id="ws_#{i}">
                    <span class="id">#{w[:id]}</span>
                    <span class="name">#{w[:name]}</span>
                    <form id="delete_#{w[:id]}" action="/widgets/#{w[:id]}" method="POST">
                      <button type="submit" value="Delete" />
                    </form>
                  </li>
        EOF
      end
      content << <<-EOF
                </ul>
                <a href="/widgets/new">New Widget</a>
              </div>
            </body>
          </html>
      EOF
      body content
    end

    error do
      e = request.env['sinatra.error']
      body << <<-EOF
          <html>
            <head>
              <title>Internal Server Error</title>
            </head>
            <body>
              <pre>
      #{e.to_s}\n#{e.backtrace.join("\n")}
              </pre>
            </body>
          </html>
      EOF
    end
  end
end
