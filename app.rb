require "sinatra"
require "sinatra/reloader"
require "dotenv/load"
require "http"

key = ENV.fetch("EXCHANGE_RATE_KEY")

get("/") do
  @raw_response = HTTP.get("https://api.exchangerate.host/list?access_key=#{key}")
  @string_response = @raw_response.to_s
  @parsed_response = JSON.parse(@string_response)
  @currencies = @parsed_response.fetch("currencies")
  erb(:homepage)
end

get("/:first_symbol") do
  @first_symbol = params.fetch("first_symbol")
  @raw_response = HTTP.get("https://api.exchangerate.host/list?access_key=#{key}")
  @string_response = @raw_response.to_s
  @parsed_response = JSON.parse(@string_response)
  @currencies = @parsed_response.fetch("currencies")
  erb(:first_step)
end

get("/:first_symbol/:second_symbol") do
  @first_symbol = params.fetch("first_symbol")
  @second_symbol = params.fetch("second_symbol")
  @raw_response = HTTP.get("https://api.exchangerate.host/convert?from=#{first_symbol}&to=#{second_symbol}&amount=1&access_key=#{key}")
  @string_response = @raw_response.to_s
  @parsed_response = JSON.parse(@string_response)
  @amount = @parsed_response.fetch("result")
  erb(:second_step)
end
