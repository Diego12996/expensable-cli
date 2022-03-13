require "httparty"
require "json"

module Modules
  class Sessions
    include HTTParty

    base_uri("https://expensable-api.herokuapp.com")

    def self.login(credentials)
      options = {
        headers: { "Content-Type": "application/json" },
        body: credentials.to_json
      }

      response = post("/login", options)
      raise HTTParty::ResponseError, response unless response.success?

      JSON.parse(response.body, symbolize_names: true)
    end

    def self.signup(credentials)
      options = {
        headers: { "Content-Type": "application/json" },
        body: credentials.to_json
      }

      response = post("/signup", options)
      raise HTTParty::ResponseError, response unless response.success?

      JSON.parse(response.body, symbolize_names: true)
    end

    def self.logout(token)
      options = {
        headers: { Authorization: "Token token=#{token}" }
      }

      response = post("/logout", options)
      raise HTTParty::ResponseError, response unless response.success?
    end
  end
end
