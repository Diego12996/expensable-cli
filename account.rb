require 'json'
require_relative "modules/helpers"
require_relative "modules/categories"
require_relative "modules/sessions"
class Account
  attr_reader :name, :date, :categories, :view_month

  include Services
  include Helpers
  def initialize(token)
    @name = "expense"
    @date =  Date.new(2021,12) #Actual Date for instruccions
    @token = token
    @categories = Categories.index(@token)
    @view_month = show_categories
  end
  

  def toggle
    @name = (@name == "expense") ? "income" : "expense"
    @view_month = show_categories
  end
  
  def change_week(change_value)
    @date = @date.next_month if change_value == "next"
    @date = @date.prev_month if change_value == "prev"
    @view_month = show_categories
  end

  def total_amount_per_month(transactions)
    total = 0
    transactions.each do |transaction|
      transaction_date = Date.parse(transaction[:date])
      next unless transaction_date.month == @date.month && transaction_date.year == @date.year
      
      total += transaction[:amount]
    end
    total
  end

  def show_categories
    rows = []
    @categories.each do |category|
      if category[:transaction_type] == @name
        total = total_amount_per_month(category[:transactions])
        if !total.zero? || category[:transactions].empty?
          rows.push([category[:id], category[:name], total]) 
        end
      end
    end
    rows.sort_by(&:first)
  end

  # ---- FORMS METHODS TO CATEGORY ----
  # -- Form Create Category --
  def create_category
    name = get_string("name", required: true)
    transaction_type = get_string("Transaction type", required: true)
    new_category = Categories.create(@token, { name: name, transaction_type: transaction_type })
    @categories = categories.push(new_category)
    @view_month = show_categories
  end

  # -- Form Update Category --
  def update_category(id)
    name = get_string("name")
    transaction_type = get_string("Transaction type")
    update_category = Categories.update(@token, id, { name: name, transaction_type: transaction_type })
    find_category = @categories.find { |category| category[:id] == id }
    find_category.update(update_category)
    @view_month = show_categories
  end

  # -- Form Delete Category --
  def delete_category(id)
    delete_category = Categories.delete(@token, id)
    @categories.reject! { |category| category[:id] == id}
    @view_month = show_categories
  end
  # ---- END FORMS TO CATEGORY ----
end

# user = Sessions.login({email: "test1@mail.com", password: "123456"})
# account = Account.new(user[:token])

# account.show_categories