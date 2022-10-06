#!/usr/bin/env ruby

require "aws-sdk"
require "json"
require "colorize"

Aws.config.update({region: "us-west-2", endpoint: "http://127.0.0.1:8000"})
dynamodb = Aws::DynamoDB::Client.new
table_name = "Movies"

params = {
    table_name: table_name,
    key_condition_expression: "#yr = :yyyy",
    expression_attribute_names: {
        "#yr" => "year"
    },
    expression_attribute_values: {
        ":yyyy" => 1985
    }
}
puts "Querying for movies from 1985.".blue

begin
  result = dynamodb.query(params)
  puts "Query succeeded.".green

  result.items.each{|movie|
    puts "#{movie["year"].to_i} #{movie["title"]}".green
  }
rescue  Aws::DynamoDB::Errors::ServiceError => error
  puts "Unable to query table: #{error.message}".red
end
