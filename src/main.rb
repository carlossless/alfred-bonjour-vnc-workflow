#!/usr/bin/env ruby

require 'rubygems' unless defined? Gem
require './bundle/bundler/setup'
require 'dnssd'
require 'timeout'
require 'json'

replies = []

begin
  Timeout.timeout 0.01 do
    DNSSD.browse! '_rfb._tcp' do |reply|
      replies << reply
    end
  end
rescue Timeout::Error # rubocop:disable Lint/HandleExceptions
end

hostnames = replies.map(&:fullname).uniq.map do |service_name|
  service_name[0..-1]
end

items = hostnames.map do |host|
  {
    title: host,
    subtitle: "vnc://#{host}",
    arg: "vnc://#{host}"
  }
end

result = { items: items }.to_json
print "#{result}\n"
