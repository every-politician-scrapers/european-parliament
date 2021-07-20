#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/wikidata_query'

query = <<SPARQL
  SELECT (STRAFTER(STR(?member), STR(wd:)) AS ?item) ?id ?name ?country (STRAFTER(STR(?ps), '/statement/') AS ?psid)
  WHERE {
    ?member p:P39 ?ps .
    ?ps ps:P39 wd:Q27169 ; pq:P2937 wd:Q64038205 .
    FILTER NOT EXISTS { ?ps pq:P582 ?end }

    OPTIONAL {
      ?ps pq:P768 ?district .
      ?district wdt:P17 ?districtCountry .
      OPTIONAL { ?districtCountry rdfs:label ?country FILTER(LANG(?country) = "en") }
    }

    OPTIONAL { ?member wdt:P1186 ?id }

    OPTIONAL { ?ps prov:wasDerivedFrom/pr:P1810 ?p39Name }
    OPTIONAL { ?member rdfs:label ?enLabel FILTER(LANG(?enLabel) = "en") }
    BIND(COALESCE(?p39Name, ?enLabel) AS ?name)
  }
  ORDER BY ?country ?name
SPARQL

agent = 'every-politican-scrapers/european-parliament'
puts EveryPoliticianScraper::WikidataQuery.new(query, agent).csv
