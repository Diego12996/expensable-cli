require 'json'
require_relative "modules/helpers"
require_relative "modules/categories"
require_relative "modules/sessions"
class Account
  attr_reader :date

  include Services
  include Helpers
  def initialize(token)
    @name = "expense"
    @date =  Date.new(2021,12) #Actual Date for instruccions
    @token = token
    @categories = Categories.index(@token)
  end
  

  def toggle
    @name = (@name == "expense") ? "income" : "expense"
  end
  
  def transactions_filter(transactions)
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
        total = transactions_filter(category[:transactions])
        rows.push([category[:id], category[:name], total]) unless total.zero?
      end
    end
    print_table("#{parse_name(@name)}\n#{parse_date(@date)}", ["ID", "Category", "Total"], rows)
  end

end

user = Sessions.login({email: "test1@mail.com", password: "123456"})
account = Account.new(user[:token])

account.show_categories