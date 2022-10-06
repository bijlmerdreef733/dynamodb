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
    condition_expression: "info.rating <= :val",
    expression_attribute_values: {
        ":val" => 5
    }
}

begin
  dynamodb.delete_item(params)
  puts "Deleted item."
rescue  Aws::DynamoDB::Errors::ServiceError => error
  puts "Unable to delete item: #{error.message}".red
end
