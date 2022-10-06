#!/usr/bin/env ruby

require "aws-sdk"
require "json"
require "colorize"

Aws.config.update({region: "us-west-2", endpoint: "http://127.0.0.1:8000"})
dynamodb = Aws::DynamoDB::Client.new
table_name = 'Movies'
file = File.read('moviedata.json')
movies = JSON.parse(file)

movies.each do |movie|
  # puts movie
  params = {
    table_name: table_name,
    item:       movie
  }
  begin
    result = dynamodb.put_item(params)
    puts "Added movie: #{movie["year"]} #{movie["title"]}".green
  rescue  Aws::DynamoDB::Errors::ServiceError => error
    puts "Unable to add movie: #{error.message}".red
  end
end
