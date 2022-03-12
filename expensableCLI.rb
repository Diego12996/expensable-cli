require_relative "modules/sessions"
require_relative "modules/helpers"
require_relative "account"
class ExpensableCLI
include Helpers

  def initialize
    @user = nil
    @account = nil
    @notes = []
  end

  def menu_user
    intro
    action = ""

    until action == "exit"
      action = login_menu
      begin
        case action
        when "login"
          login
        when "create_user"
          create_user
        when "exit"
          exit
        else
          puts "Invalid options"
        end
      rescue HTTParty::ResponseError => error
        parsed_error = JSON.parse(error.message, symbolize_names: true)
        puts parsed_error
      end
    end
  end
  # ---- Methods for user ----
  def create_user
    credentials = create_form
    @user = Modules::Sessions.signup(credentials)
  end

  def login
    credentials = login_form
    @user = Modules::Sessions.login(credentials)
    puts "Welcome back #{@user[:first_name]} User"
    menu_account
  end
 
  def logout
    @user = Modules::Sessions.logout(@user[:token])
  end
# ---- End Methods for user ----

# ---- View ----
  def menu_account
    @account = Account.new(@user[:token]) 
    loop do
      print_table("#{parse_name(@account.name)}\n#{parse_date(@account.date)}",
                  ["ID", "Category", "Total"], @account.view_month)
        # print table for Expenses and Incomes
      action, id = account_menu
      id = id.to_i
      case action
      when "create" then @account.create_category
      when "show" then menu_category(id)
      when "update" then @account.update_category(id)
      when "delete" then @account.delete_category(id)
      when "add-to" then @account.add_to_transaction(id)
      when "toggle" then @account.toggle
      when "next" then @account.change_week("next")
      when "prev" then @account.change_week("prev")
      when "logout"
        break
      end
    end
    print_table("#{parse_name(@account.name)}\n#{parse_date(@account.date)}",
               ["ID", "Category", "Total"], @account.view_month)
  end
  def menu_category(id)
    loop do 
    end
  end
end

prueba = ExpensableCLI.new
prueba.menu_user
