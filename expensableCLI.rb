require_relative "modules/sessions"
require_relative "modules/helpers"

class ExpensableCLI
include Helpers

  def initialize
    @user = nil
    @notes = []
  end


  def main_menu
    intro
    action = ""

    until action == "exit"
      action = get_with_options(["login", "create_user", "exit"])
      begin
        case action
        when "login"
          login
        when "create_user"
          create_user
        when "exit"
          logout
        end
      rescue HTTParty::ResponseError => error
        parsed_error = JSON.parse(error.message, symbolize_names: true)
        puts parsed_error
      end
    end
  end

  def create_user
    credentials = create_form
    @user = Modules::Sessions.signup(credentials)
  end

  def login
    credentials = login_form
    @user = Modules::Sessions.login(credentials)
  end
 
  def logout
    @user = Modules::Sessions.logout
  end

end

prueba = Expensable.new
prueba.main_menu
