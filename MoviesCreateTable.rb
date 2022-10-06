#!/usr/bin/env ruby

require "aws-sdk"
require "colorize"

Aws.config.update({endpoint: "http://127.0.0.1:8000"})
dynamodb = Aws::DynamoDB::Client.new
table_name = 'Movies'

params = {
    table_name: table_name,
    key_schema: [
        {
            attribute_name: "year",
            key_type: "HASH"  #Partition key
        },
        {
            attribute_name: "title",
            key_type: "RANGE" #Sort key
        }
    ],
    attribute_definitions: [
        {
            attribute_name: "year",
            attribute_type: "N"
        },
        {
            attribute_name: "title",
            attribute_type: "S"
        },

    ],
    provisioned_throughput: {
        read_capacity_units: 10,
        write_capacity_units: 10
    }
}

begin
  result = dynamodb.create_table(params)
  puts "Created table. Status: #{result.table_description.table_status}".green
rescue  Aws::DynamoDB::Errors::ServiceError => error
  puts "Unable to create table: #{error.message}".red
end
