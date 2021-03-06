# coding: utf-8
require 'populator'
require 'faker'

namespace :db do
  desc "Erase and fill database"
  task :articles => :environment do
    ArticleTag.destroy_all
    Article.destroy_all
    Article.populate 10..100 do |article|
      article.title = Populator.words(1..5).titleize
      article.text = Populator.sentences(2..30)
      article.date = Time.now
    end
  end

  task :events => :environment do
    Event.destroy_all
    FrontImage.destroy_all
    Event.populate 3 do |event|
      event.title = Populator.sentences(1)
      event.date = Date.today + rand(200)
      event.text = Populator.sentences(20..40)
      event.event_type_id = EventType.pluck(:id)
      event.main = %w[true false]
      event.shorttext = Populator.words(3)
      event.eventdetails = Populator.words(3)
      event.price = %w[500 1000 1500 2000]
      event.published = true
      event.property = 'master'
      event.filled = false
    end
    puts "Future events created!"
    
    Event.populate 3 do |event|
      event.title = Populator.sentences(1)
      event.date = Date.today - rand(200)
      event.text = Populator.sentences(20..40)
      event.event_type_id = EventType.pluck(:id)
      event.main = %w[true false]
      event.shorttext = Populator.words(3)
      event.eventdetails = Populator.words(3)
      event.price = %w[500 1000 1500 2000]
      event.published = true
      event.property = 'master'
      event.filled = false
    end
    puts "Past events created!"
    
    Event.populate 3 do |event|
      event.title = Populator.sentences(1)
      event.text = Populator.sentences(20..40)
      event.event_type_id = EventType.pluck(:id)
      event.main = %w[true false]
      event.shorttext = Populator.words(3)
      event.eventdetails = Populator.words(3)
      event.price = %w[500 1000 1500 2000]
      event.published = true
      event.property = 'course'
      event.filled = false
    end
    puts "Courses created!"

    
    Event.all.each do |event|
      FrontImage.create(:event_id => event.id, :image => File.open(Dir.glob(File.join(Rails.root, 'covers', '*')).sample))
    end
    puts "Front images attached!"
    
  end
  
  
  
end

namespace :mail do
  desc "Erase and fill database"
  task :distribute => :environment do
    SubscriptionMailer.events_feed_email.deliver
  end
end

namespace :pages do
  desc "Erase and fill database"
  task :populate => :environment do
    Page.create!(:section => 'about', :title => 'О школе', :text => 'О школе')
    Page.create!(:section => 'teach_list', :title => 'Что преподаем', :text => 'Что преподаем')
  end
end