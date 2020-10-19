#!/usr/bin/env ruby

require 'rubygems' unless defined? Gem
require './bundle/bundler/setup'
require 'dnssd'
require 'timeout'
require 'json'
require 'fuzzy_match'

replies = []
query = ARGV.first && ARGV.first.strip

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

hostnames = FuzzyMatch.new(hostnames).find_all(query) unless query.nil? || query.empty?

items = hostnames.map do |host|
  {
    title: host,
    subtitle: "vnc://#{host}",
    arg: "vnc://#{host}"
  }
end

query = ARGV.first.strip
if !query.nil? && !query.empty?
  items.append({
    title: query,
    subtitle: "vnc://#{query}",
    arg: "vnc://#{query}"
  })
end

result = { items: items }.to_json
print "#{result}\n"
