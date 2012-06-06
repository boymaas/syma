require 'sinatra_app/simple'
require 'rack/test'
require 'hpricot'

ENV['RACK_ENV'] = 'test'

module SinatraApp
  describe "The Simple App" do
    include Rack::Test::Methods

    def app
      Simple
    end

    before { Simple.clear }

    def sign_in
      Simple.create_user(:email=>'existing', :password => 'password')
      post "/session", :email => :existing, :password => :password
    end

    context "get /session/new" do
      it "returns the input form"  do
        get '/session/new'    
        last_response.should be_ok
        last_response.body.should include('Sign In')
      end
    end

    context "post /session" do
      context "given: user exists" do
        it "creates a session" do
          Simple.create_user(:email=>'existing', :password => 'password')
          post "/session", :email => :existing, :password => :password
          last_response.should be_ok
          last_response.body.should include('You are logged in!')
        end
      end
      
      context "given: user does not exist" do
        it "does not create a session" do
          post "/session", :email => :non_existing, :password => :password
          last_response.status.should == 403
          last_response.body.should include('Log in failed!')
        end
      end
    end

    context "post /widgets" do
      it "stores a new widget" do
        post '/widgets', :name => 'Foo'
        last_response.should be_an_redirect
      end
    end
    context "post /widgets/:widget_id" do
      it "stores a new widget" do
        widget = Simple.create_widget(:name => 'New Widget')
        post '/widgets/%s' % widget.fetch(:id)
        last_response.should be_an_redirect
        Simple.widgets.should_not include(widget)
      end
    end
    context "get /widgets/new" do
      before { sign_in }
      it "displays the form" do
        get '/widgets/new'
        last_response.body.should include('widget_form')
        last_response.body.should include('name')
        last_response.body.should include('Name:')
      end
    end
    context "get /widgets" do
      before { sign_in }
      context "given: widgets exist" do
        before do
          first_widget
          last_widget

          get '/widgets'
        end

        let(:first_widget) { Simple.create_widget(:name => 'First Widget')   }
        let(:last_widget) { Simple.create_widget(:name => 'Last Widget')   }

        let(:doc) { Hpricot(last_response.body) }

        let(:widget_list) { (doc/"#widget_list") }
        let(:widget_list_items) { (doc/"#widget_list ul li") }
        let(:last_widget_created) { (doc/"#widget_list .last_widget") }

        it("widget list present") { widget_list.count.should == 1 }
        it("items in widgetlist") { widget_list_items.count.should == 2 }
        it("last widget created") { last_widget_created.count.should == 1 }
        it("id correct of lwc") { (last_widget_created/".id").text.should == last_widget[:id] }
        it("name correct of lwc") { (last_widget_created/".name").text.should == 'Last Widget' }

      end
    end
  end
end
