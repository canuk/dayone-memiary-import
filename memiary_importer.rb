require 'nokogiri'
require 'time'
require "rb-dayone"
require 'reverse_markdown'

filename = ARGV[0]
file = File.open(filename)
xml = Nokogiri::XML(file)

# replace \n and any additional whitespace with a space
xml.xpath("//item").each do |node|
  journal_entry = ReverseMarkdown.convert node.xpath("description").text
  journal_date = Time.parse(node.xpath("pubDate").text)
  journal_entry.sub!(/_These memories were recorded on \[Memiary\]\(http:\/\/www.memiary.com\/\), the weightless pocket diary._/,'')

		puts "-------------------------------------------------------------"
		puts journal_date
		puts journal_entry
    e = DayOne::Entry.new
    e.creation_date = journal_date
    e.entry_text = "# Memories from today.\n"+journal_entry
    e.tags = ['memiary']
    e.create!

		puts "-------------------------------------------------------------"
end