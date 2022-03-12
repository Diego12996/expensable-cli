require "httparty"
require "json"

module Services
  class Transactions
    include HTTParty
    
    base_uri("https://expensable-api.herokuapp.com")

    def self.create(token, id, parameters)
      options = {
        headers: { 
          Authorization: "Token token=#{token}",
          "Content-Type": "application/json"
        },
        body: parameters.to_json
      }

      response = post("/categories/#{id}/transactions", options)
      raise HTTParty::ResponseError.new(response) unless response.success?
      puts JSON.parse(response.body, symbolize_names: true)
    end
  end
end
