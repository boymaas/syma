require 'syma'

module SinatraApp

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

  class SignInScreen < Syma::UIComponent
    component_path '/session/new'
    component_selector '#sign_in_screen'

    def sign_in(user_data)
      in_world_within do
        fill_in 'Email:', :with => user_data[:email]
        fill_in 'Password:', :with => user_data[:password]
        click_button 'Sign In'
      end
    end
  end

  class WidgetList < Syma::UIComponent
    component_path '/widgets'
    component_selector '#widget_list'

    def widgets
      w.all('.widget_summary').map do |el|
        extract_widget_data(el)
      end
    end

    def last_widget_created
      element = w.find('.last_widget.created')
      extract_widget_data(element)
    end

    def choose_to_create_new_widget
      w.click_on 'New Widget'
    end

    def choose_to_delete_widget(widget_data)
      w.find("#delete_#{widget_data[:id]}").click_button('Delete')
    end

    private

    def extract_widget_data(element)
      {
        :id => element.find('.id').text,
        :name => element.find('.name').text
      }
    end
  end

  class WidgetForm < Syma::UIComponent
    component_selector '#widget_form'

    def submit(widget_data)
      w.fill_in 'Name:', :with => widget_data[:name]
      w.click_on 'Save'
    end
  end

  class UIDriver < Syma::UIDriver
    ui_component :sign_in_screen, SignInScreen
    ui_component :widget_list, WidgetList
    ui_component :widget_form, WidgetForm

    def sign_in(name)
      go_to sign_in_screen
      sign_in_screen.sign_in(mental_model.users[name])
    end

    def view_widget_list
      go_to widget_list
    end

    def create_new_widget(name, attributes = {})
      raise  "Widget list is not visible!" unless widget_list.visible?
      widget_list.choose_to_create_new_widget
      widget_form.submit(:name => 'My Widget')
      mental_model.widgets[name] = widget_list.last_widget_created
    end

    def delete_widget(name)
      raise  "Widget list is not visible!" unless widget_list.visible?
      widget_list.choose_to_delete_widget(mental_model.widgets.delete(name))
    end
  end
end
