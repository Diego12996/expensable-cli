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
      JSON.parse(response.body, symbolize_names: true)
    end

    def self.update(token, id, id_category, parameters)
      options = {
        headers: { 
          Authorization: "Token token=#{token}",
          "Content-Type": "application/json"
        },
        body: parameters.to_json
      }

      response = patch("/categories/#{id_category}/transactions/#{id}", options)
      raise HTTParty::ResponseError.new(response) unless response.success?
      JSON.parse(response.body, symbolize_names: true)
    end


    def self.destroy(token, id, id_category)
      options = {
        headers: { Authorization: "Token token=#{token}" }
      }

      response = delete("/categories/#{id_category}/transactions/#{id}", options)
      raise HTTParty::ResponseError.new(response) unless response.success?
    end
  end
end
