// xsv join id data/official.csv id data/wikidata.csv | xsv search $ID | xsv select 'psid,name'  |
//   awk -F, '{ print $1, "\""$2"\"" }' | tail -1 | xargs wb ar add-source-name.js

module.exports = (guid, name) => ({
    guid,
    snaks: {
      P854: 'https://www.europarl.europa.eu/meps/en/full-list/xml',
      P813: new Date().toISOString().split('T')[0],
      P1810: name
    }
})
