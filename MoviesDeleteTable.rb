#!/usr/bin/env ruby

require "aws-sdk"
require "colorize"

Aws.config.update({region: "us-west-2", endpoint: "http://127.0.0.1:8000"})
dynamodb = Aws::DynamoDB::Client.new

params = {
  table_name: "Movies"
}

begin
  dynamodb.delete_table(params)
  puts "Deleted table.".green

rescue  Aws::DynamoDB::Errors::ServiceError => error
  puts "Unable to delete table:".red
  puts "#{error.message}".red
end
