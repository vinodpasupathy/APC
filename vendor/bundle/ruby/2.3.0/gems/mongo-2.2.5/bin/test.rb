#!/usr/bin/env ruby

$LOAD_PATH[0, 0] = File.join(File.dirname(__FILE__), '..', 'lib')
require 'pry'
require 'mongo'

# include the mongo namespace
include Mongo

#gem 'mongo', '2.2.4' # this version raises "Cursor not found"
# gem 'mongo', '2.1.2' # this version works

#require 'uri'
#require 'mongo'

#binding.pry
puts "-" * 50
puts "Mongo Driver version: #{Mongo::VERSION}"
puts "-" * 50

uri = "mongodb://emily:qWQ6wfYfM5v7FGFf@aws-us-east-1-portal.14.dblayer.com:11118,aws-us-east-1-portal.13.dblayer.com:11141/tests?ssl=true"
#uri = "mongodb://localhost:2323,localhost:2324"
c = Mongo::Client.new(uri, ssl: true, ssl_verify: false, max_pool_size: 10)
#c = Mongo::Client.new(uri)

# c = Mongo::Client.new(["server:3000", "server:3001", "server:3002"],
#                        :ssl => true,
#                        :ssl_cert => "/Users/emily/ssl-certificates/client.pem",
#                        :ssl_key => "/Users/emily/ssl-certificates/client.pem",
#                        :ssl_ca_cert =>  "/Users/emily/ssl-certificates/ca.pem",
#                        :max_pool_size => 20)

binding.pry

c['samplecol'].drop
c['samplecol'].insert_many(50.times.map { |i| { someval: i } })

10.times.map { Thread.start { c['samplecol'].find({}).batch_size(10).to_a } }.map(&:join)

