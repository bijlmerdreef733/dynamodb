#!/usr/bin/env ruby

require "aws-sdk"
require "json"
require "colorize"

Aws.config.update({region: "us-west-2", endpoint: "http://127.0.0.1:8000"})
dynamodb = Aws::DynamoDB::Client.new
table_name = 'Movies'
year = 2015
title = "The Big New Movie"

params = {
  table_name: table_name,
  key: {
    year: year,
    title: title
  },
  update_expression: "remove info.actors[0]",
  condition_expression: "size(info.actors) >= :num",
  expression_attribute_values: {
    ":num" => 2
  },
  return_values: "UPDATED_NEW"
}

begin
  result = dynamodb.update_item(params)
  puts "Updated item. ReturnValues are:"
  result.attributes["info"].each do |key, value|
    if key == "rating"
      puts "#{key}: #{value.to_f}".green
    else
      puts "#{key}: #{value}".blue
    end
  end

rescue  Aws::DynamoDB::Errors::ServiceError => error
  puts "Unable to update item: #{error.message}".red
end
