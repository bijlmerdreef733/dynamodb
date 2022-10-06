#!/usr/bin/env ruby

require "aws-sdk"
require "json"
require "colorize"

Aws.config.update({region: "us-west-2", endpoint: "http://127.0.0.1:8000"})
dynamodb = Aws::DynamoDB::Client.new
table_name = 'Movies'

year = 2015
title = "The Big New Movie"

key = {
  year: year,
  title: title
}

params = {
  table_name: table_name,
  key: {
    year: year,
    title: title
  }
}
begin
  result = dynamodb.get_item(params)
  printf "%i - %s\n%s\n%d\n",
         result.item["year"],
         result.item["title"],
         result.item["info"]["plot"],
         result.item["info"]["rating"]

  # puts "Added item: #{year}  - #{title}".green
rescue  Aws::DynamoDB::Errors::ServiceError => error
  puts "Unable to read item: #{error.message}".red
end
