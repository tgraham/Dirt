time = Time.new

content = ""
open("http://rssfeeds.s3.amazonaws.com/goldbox") do |s| content = s.read end
rss = RSS::Parser.parse(content, false)
gb = rss.items.first

get '/' do
  @gb = gb
  @time = time
  haml :index
end

get '/about' do
  @time = time
  haml :about
end

get '/rss' do
  require 'rss/maker'

  version = "2.0" # ["0.9", "1.0", "2.0"]
  destination = "public/dirt.xml" # local file to write

  content = RSS::Maker.make(version) do |m|
  m.channel.title = "DIRT.US - Deal of the Day from Amazon's GoldBox"
  m.channel.link = "http://dirt.us"
  m.channel.description = "Deal of the Day from Amazon's GoldBox"
  m.items.do_sort = true # sort items by date

  i = m.items.new_item
  i.title = gb.title.gsub('Deal of the Day: ', '')
  i.link = "http://dirt.us/"
  i.date = gb.pubDate
  end

  File.open(destination,"w") do |f|
  f.write(content)
  end
end