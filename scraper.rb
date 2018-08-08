require 'nokogiri'
require 'httparty'
require 'byebug'

def scraper
  url = 'https://blockwork.cc/'

  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  job_listings = parsed_page.css('div.listingCard')
  per_page = job_listings.count  #50jobs per page
  total = parsed_page.css('div.job-count').text.scan(/\d+/).join.to_i #2287
  last_page = (total.to_f/per_page.to_f).round  #page46
  page = 1
  jobs = []
  while page <= last_page do
    pagination_url = "https://blockwork.cc/listings?page=#{page}"
    puts pagination_url
    puts "Page #{page}"
    puts ''
    pagination_unparsed_page = HTTParty.get(pagination_url)
    pagination_parsed_page = Nokogiri::HTML(unparsed_page)
    pagination_job_listings = parsed_page.css('div.listingCard')
    job_listings.each do |job_listing|
      job = {
              title: job_listing.css('span.job-title').text,
              company: job_listing.css('span.company').text,
              location: job_listing.css('span.location').text,
              href: 'https://blockwork.cc' + job_listing.css('a')[0].attributes['href'].value
            }
      jobs << job
      puts "Added #{job[:title]}"
      puts ''
    end
    page += 1
  end
end

scraper
