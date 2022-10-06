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
    update_expression: "set info.rating = :r, info.plot=:p, info.actors=:a",
    expression_attribute_values: {
        ":r" => 5.5,
        ":p" => "Everything happens all at once.", # value <Hash,Array,String,Numeric,Boolean,IO,Set,nil>
        ":a" => ["Larry", "Moe", "Curly"]
    },
    return_values: "UPDATED_NEW"
}

begin
  result = dynamodb.update_item(params)
  puts "Added item: #{year}  - #{title}".green
rescue  Aws::DynamoDB::Errors::ServiceError => error
  puts "Unable to read item: #{error.message}".red
end
