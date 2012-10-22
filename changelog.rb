#!/usr/bin/env ruby

require 'net/http'
require 'rubygems'
require 'json'

HOST = "localhost:8080"
USER = "admin"
PASSWORD = "password"

def retrieve_json
  uri = URI.parse("http://#{HOST}/job/#{ENV['JOB_NAME']}/#{ENV['BUILD_NUMBER']}/api/json")
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.path)
  request.basic_auth(USER, PASSWORD)
  response = http.request(request)
  JSON.parse(response.body)
end 

def create_changelog (json_data)
  comments = []
  length = 0 
  json_data['changeSet'].each do |key,value| 
    if value
      value.each do |item|
        comment = "* " << item['msg'] << " (" << item['author']['fullName'] << ")" << "\n"
        length += comment.length
                
        if length < 4980
          comments << comment
        else
          comments << "* And many more ...\n"
          break
        end 
      end 
    end 
  end 
  comments.join
end 

def write_changelog (data)
  open('change.log', 'w') do |f| 
    f << data
  end 
end 

def write
  json_data = retrieve_json
  write_changelog(create_changelog(json_data))
end 

write()

