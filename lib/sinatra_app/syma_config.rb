require 'syma'

module SinatraApp

  ## SignInSreen and WidgetList interface componentes

  class SignInScreen < Syma::UIComponent
    component_path '/session/new'
    component_selector '#sign_in_screen'

    def_text_field_accessor      :email, :selector => 'input#email'
    def_password_field_accessor  :password, :selector => 'input#password'
    def_submitter                :press_sign_in, :selector => 'Sign In'

    def sign_in(user_data)
      email    user_data[:email]
      password user_data[:password]
      press_sign_in
    end
  end

  # WidgetScreen and the form on this screen

  class WidgetForm < Syma::UIComponent
    component_selector '#widget_form'

    def_text_field_accessor :name, :selector => 'input#name'
    def_submitter           :press_save, :selector => 'Save'

    def save_widget(widget_data)
     fill_in 'Name:', :with => widget_data[:name]
     press_save
    end
  end

  class WidgetElement < Syma::UIComponent
    def initialize(conf, id)
      @component_selector = id
      super(conf)
    end

    def_text_lookup_reader :id, :selector => '.id'
    def_text_lookup_reader :name, :selector => '.name'
  end

  class WidgetScreen < Syma::UIComponent
    component_path '/widgets'
    component_selector '#widget_list'

    ui_component :form, WidgetForm

    def widgets_data
      all('.widget_summary').map do |el|
        extract_widget_data(el)
      end
    end

    def widgets
      w = []
      all('.widget_summary').each_with_index do |el,i|
        w << WidgetElement.new(configuration, "#ws_#{i}")
      end
      w
    end

    def last_widget_created
      element = find('.last_widget.created')
      extract_widget_data(element)
    end

    def choose_to_create_new_widget
      click_on 'New Widget'
    end

    def choose_to_delete_widget(widget_data)
      find("#delete_#{widget_data.fetch(:id)}").click_button('Delete')
    end

    private

    def extract_widget_data(element)
      {
        :id => element.find('.id').text,
        :name => element.find('.name').text
      }
    end
  end


  # Drivers

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


  class UIDriver < Syma::UIDriver
    ui_component :sign_in_screen, SignInScreen
    ui_component :widget_screen, WidgetScreen

    def sign_in(name)
      go_to sign_in_screen
      sign_in_screen.sign_in(mental_model.users[name])
    end

    def view_widget_screen
      go_to widget_screen
    end

    def create_new_widget(name, attributes = {})
      raise  "Widget list is not visible!" unless widget_screen.visible?
      widget_screen.choose_to_create_new_widget
      widget_screen.form.save_widget(:name => 'My Widget')
      mental_model.widgets[name] = widget_screen.last_widget_created
    end

    def delete_widget(name)
      raise  "Widget list is not visible!" unless widget_screen.visible?
      widget_screen.choose_to_delete_widget(mental_model.widgets.delete(name))
    end
  end
end
