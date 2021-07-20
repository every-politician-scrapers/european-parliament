#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'open-uri/cached'
require 'pry'

class Legislature
  # details for an individual member
  class Member < Scraped::HTML
    field :id do
      noko.xpath('./id').text
    end

    field :name do
      noko.xpath('./fullname').text
    end

    field :country do
      noko.xpath('./country').text
    end

    field :group do
      noko.xpath('./politicalgroup').text
    end

    field :national_group do
      noko.xpath('./nationalpoliticalgroup').text
    end
  end

  # The document listing all the members.
  # It's XML, but we can treat it as HTML
  class Members < Scraped::HTML
    field :members do
      members_list.map { |mp| fragment(mp => Member).to_h }
    end

    private

    def members_list
      noko.xpath('//mep')
    end
  end
end

url = 'https://www.europarl.europa.eu/meps/en/full-list/xml'
puts EveryPoliticianScraper::ScraperData.new(url).csv
