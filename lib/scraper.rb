require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    doc = Nokogiri::HTML(open(index_url))
    doc.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|  
        profile_l = "#{student.attr('href')}"
        loc = student.css('.student-location').text
        name = student.css('.student-name').text
        students << {name: name, location: loc, profile_url: profile_l}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    profile_page = Nokogiri::HTML(open(profile_url))
    links = profile_page.css(".social-icon-container").children.css("a").map {|l| l.attribute('href').value}
    links.each do |l|
      if l.include?("linkedin")
        student[:linkedin] = l
      elsif l.include?("github")
        student[:github] = l
      elsif l.include?("twitter")
        student[:twitter] = l
      else
        student[:blog] = l
      end
    end
    student[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
    student[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text if profile_page.css("div.bio-content.content-holder div.description-holder p")

    student
  end

end

