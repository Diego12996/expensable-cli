require_relative "modules/helpers"
require_relative "modules/sessions"
require_relative "account"
require_relative "category"

class ExpensableCLI
  include Helpers
  include Modules
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
        when "login" then login
        when "create_user" then create_user
        when "exit"then exit
        else
          puts "Invalid options"
        end
      rescue HTTParty::ResponseError => e
        parsed_error = JSON.parse(e.message, symbolize_names: true)
        puts parsed_error
      end
    end
  end

  # ---- Methods for user ----
  def create_user
    credentials = create_form
    @user = Sessions.signup(credentials)
  end

  def login
    credentials = login_form
    @user = Sessions.login(credentials)
    puts "Welcome back #{@user[:first_name]} User"
    menu_account
  end

  def logout
    @user = Sessions.logout(@user[:token])
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
      validation = @account.find_category(id).nil?
      case action
      when "create" then @account.create_category
      when "show" then validation ? (puts "Not Found") : menu_category(id)
      when "update" then validation ? (puts "Not Found") : @account.update_category(id)
      when "delete" then validation ? (puts "Not Found") : @account.delete_category(id)
      when "add-to" then validation ? (puts "Not Found") : @account.add_to_transaction(id)
      when "toggle" then @account.toggle
      when "next" then @account.change_week("next")
      when "prev" then @account.change_week("prev")
      when "logout"
        break
      end
    end
    # print_table("#{parse_name(@account.name)}\n#{parse_date(@account.date)}",
    # ["ID", "Category", "Total"], @account.view_month)
  end

  def menu_category(id_category)
    category = Category.new(@user[:token], @account.date, @account.find_category(id_category))
    loop do
      print_table("#{parse_name(category.name)}\n#{parse_date(category.date)}",
                  ["ID", "Date", "Amount", "Notes"], category.show_category)
      action, id = category_menu
      id = id.to_i
      validation = category.find_transaction(id).nil?
      case action
      when "add" then validation ? (puts "Not Found") : @account.add_to_transaction(id_category)
      when "update" then validation ? (puts "Not Found") : category.update_transaction(id, id_category)
      when "delete" then validation ? (puts "Not Found") : category.delete_transaction(id, id_category)
      when "next" then category.change_week("next")
      when "prev" then category.change_week("prev")
      when "back" then break
      end
    end
  end
end

prueba = ExpensableCLI.new
prueba.menu_user
