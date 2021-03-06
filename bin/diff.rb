#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/comparison'
require 'pry'

# Process the data from each source before comparison
class Comparison < EveryPoliticianScraper::Comparison
  def wikidata_csv_options
    { converters: [->(val) { val.to_s.gsub('Republic of Ireland', 'Ireland').upcase }] }
  end

  def external_csv_options
    { converters: [->(val) { val.to_s.gsub('Czechia', 'Czech Republic').upcase }] }
  end
end

diff = Comparison.new('data/wikidata.csv', 'data/official.csv').diff
puts diff.sort_by { |r| [r.first, -r[1].to_s.to_i] }.reverse.map(&:to_csv)
