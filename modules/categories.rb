require "httparty"
require "json"

module Services
  class Categories
    include HTTParty
    
    base_uri("https://expensable-api.herokuapp.com")

    def self.index(token)
      options = {
        headers: { Authorization: "Token token=#{token}" }
      }
      #index
      response = get("/categories", options)
      JSON.parse(response.body, symbolize_names: true)
    end

    def self.create(token, parameters)
      options = {
        headers: { 
          Authorization: "Token token=#{token}",
          "Content-Type": "application/json"
        },
        body: parameters.to_json
      }
  
      response = post("/categories", options)
      raise HTTParty::ResponseError.new(response) unless response.success?
      JSON.parse(response.body, symbolize_names: true)
    end

    def self.update(token, id, parameters)
      options = {
        headers: { 
          Authorization: "Token token=#{token}",
          "Content-Type": "application/json"
        },
        body: parameters.to_json
      }

      response = patch("/categories/#{id}", options)
      raise HTTParty::ResponseError.new(response) unless response.success?
      JSON.parse(response.body, symbolize_names: true)
    end

    def self.destroy(token, id)
      options = {
        headers: { Authorization: "Token token=#{token}" }
      }

      response = delete("/categories/#{id}", options)
      raise HTTParty::ResponseError.new(response) unless response.success?
    end
  end
  
end