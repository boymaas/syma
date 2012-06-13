require 'syma/basic_object'
require 'colorize'

class Syma
  module UiSessionDriverForwardable
    def session_driver
      configuration.session_driver_instance
    end

    def in_session_driver &block
      if block.arity == 1
        block.call(session_driver)
      else
        session_driver.instance_eval(&block) 
      end
    end

    def in_scoped_session_driver &block
      session_driver.within(component_selector) do
        in_session_driver(&block)
      end
    end

    def render_file_excerp backtrace_line, size=10
      bt_file, bt_line, bt_func = backtrace_line.split(/:/)

      bt_line = bt_line.to_i
      bt_file_lines = File.open(bt_file).read.lines.to_a
      bt_file_min_line_no = [0, bt_line - size/2].max
      bt_file_section = bt_file_lines[bt_file_min_line_no,size]

      file_excerp = []
      file_excerp << "#{ bt_file }:#{ bt_file_min_line_no}-#{ bt_file_min_line_no + 6}".blue
      file_excerp.concat bt_file_section.map(&:chomp).map(&:white)
      file_excerp
    end


    def method_missing(m,*a,&block)
      if session_driver.respond_to?(m)
        begin
          session_driver.within(component_selector) do
            return session_driver.send(m, *a, &block)
          end
        rescue SessionDriver::RuntimeError => e
          bt_file, bt_line, bt_func = e.backtrace[2].split(/:/)
          message = []
          message << e.message
          message << ""
          unless self.component_path == session_driver.current_path
            message << "Suggestion: are you on the correct path?".white
          end
          message << "error message                : [%s]".red % (e.message)
          message << "session_driver.current_path  : [%s]".blue % (session_driver.current_path || :not_specified )
          message << "ui_component class           : [%s]".blue % (self.class )
          message << "ui_component selector        : [%s]".blue % (self.component_selector || :not_specified )
          message << "ui_component path            : [%s]".blue % (self.component_path || :not_specified )
          message << "calling function             : [%s]".yellow % (bt_func)
          message << ""
          message.concat render_file_excerp(e.backtrace[2])
          message << ""
          message.concat render_file_excerp(e.backtrace[3])
          message.concat e.backtrace[2,4]
          raise e.class, message.join("\n")
        end
      end
      super
    end
  end

end
