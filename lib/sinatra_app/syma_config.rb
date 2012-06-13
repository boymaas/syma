require 'syma'

module SinatraApp

  ## SignInSreen and WidgetList interface componentes

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

  # WidgetScreen and the form on this screen

  class WidgetForm < Syma::UIComponent
    component_selector '#widget_form'

    def_text_field :name, :selector => 'input#name'
    def_submitter           :press_save, :selector => 'Save'

    def save_widget(widget_data)
     fill_form_field('input#name', widget_data[:name])
     click_on 'button[text()="Save"]'
    end
  end

  class WidgetElement < Syma::UIComponent
    def initialize(conf, id)
      @component_selector = id
      super(conf)
    end

    def_text_lookup :id, :selector => '.id'
    def_text_lookup :name, :selector => '.name'
  end

  class WidgetScreen < Syma::UIComponent
    component_path '/widgets'
    component_selector '#widget_list'

    ui_component :form, WidgetForm

    def widgets_data
      each_element_matching('.widget_summary') do |el|
        extract_widget_data(el)
      end
    end

    def widgets
      w = []
      each_element_matching('.widget_summary') do |el,i|
        w << WidgetElement.new(configuration, "#ws_#{i}")
      end
      w
    end

    def last_widget_created
      element = find_element('.last_widget.created')
      extract_widget_data(element)
    end

    def choose_to_create_new_widget
      click_on 'a[text()="New Widget"]'
    end

    def choose_to_delete_widget(widget_data)
      click_on("#delete_#{widget_data.fetch(:id)} button")
    end

    private

    def extract_widget_data(element)
      {
        :id => element.find_text('.id'),
        :name => element.find_text('.name')
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
