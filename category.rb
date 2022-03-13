require_relative "modules/helpers"
require_relative "modules/transactions"
require "colorize"

class Category
  attr_reader :name, :date

  include Services
  include Helpers
  def initialize(token, date, category_hash)
    @token = token
    @name = category_hash[:name]
    @id = category_hash[:id]
    @date = date # Actual Date for instruccions
    @transactions = category_hash[:transactions]
  end

  def change_week(change_value)
    @date = @date.next_month if change_value == "next"
    @date = @date.prev_month if change_value == "prev"
  end

  def show_category
    rows = []
    @transactions.each do |transaction|
      transaction_date = Date.parse(transaction[:date])
      next unless @date.year == transaction_date.year && @date.month == transaction_date.month

      rows.push([transaction[:id], transaction_date.strftime("%a, %b %d"),
                 transaction[:amount], transaction[:notes]])
    end
    rows
  end

  def find_transaction(id)
    @transactions.find { |transaction| transaction[:id] == id }
  end

  def update_transaction(id, id_category)
    parameters = form_add_to_transaction
    parameters.delete(:notes) if parameters[:notes].empty?
    update_transaction = Transactions.update(@token, id, id_category, parameters)
    find_transaction(id).update(update_transaction)
  end

  def delete_transaction(id, id_category)
    Transactions.destroy(@token, id, id_category)
    @transactions = @transactions.reject { |transaction| transaction[:id] == id }
  end
end
