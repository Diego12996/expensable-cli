require "httparty"
require "json"

module Services
  class Categories
    include HTTParty
    
    base_uri("https://expensable-api.herokuapp.com")

    def self.index(token)
      options = {
        headers: { "Authorization": "Token token=#{token}" }
      }
      #index
      response = get("/categories", options)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end