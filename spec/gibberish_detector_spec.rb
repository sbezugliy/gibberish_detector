# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "gibberish detection for essential phrases of " do |language|
  
  describe "for #{language.capitalize}" do
    File.open(File.join(__dir__, "../fixtures/essential_phrases/#{language}.txt"), "r").each do |phrase|
      it "is not gibberish" do
        expect(phrase.gibberish?).to be_falsy, lambda { "Phrase: #{phrase}" }
      end
    end
  end
end

RSpec.shared_examples "gibberish detection for additional phrases of " do |kind, phrase|
  describe "for #{kind}" do
    it "is not gibberish" do
      expect(phrase.gibberish?).to be_falsy, lambda { "Phrase: #{phrase}" }
    end
  end
end

RSpec.shared_examples "gibberish detection for nonsense phrases of " do |kind, phrase|
  describe "for #{kind}" do
    it "is gibberish" do
      expect(phrase.gibberish?).to be_truthy, lambda { "Phrase: #{phrase}" }
    end
  end
end

RSpec.describe(GibberishDetector) do
  # include_examples "gibberish detection for essential phrases of ", "english"
  # include_examples "gibberish detection for essential phrases of ", "french"
  # include_examples "gibberish detection for essential phrases of ", "german"
  # include_examples "gibberish detection for essential phrases of ", "italian"
  # include_examples "gibberish detection for essential phrases of ", "portuguese"
  # include_examples "gibberish detection for essential phrases of ", "spanish"
  
  ['en-US', 'es', 'fr-CH', 'fr-CA', 'it', 'de', 'uk', 'ru', 'ar', 'he', 'zh-CN', 'zh-TW', 'vi', 'ko', 'hy', 'fa', 'id'].each do |locale|
    Faker::Config.locale = locale

    50.times { include_examples "gibberish detection for nonsense phrases of ", "#{locale} nonsense", Array.new(rand(3..10)) { Faker::Alphanumeric.alpha(number: rand(2..10)) }.join(' ') }

    50.times { include_examples "gibberish detection for additional phrases of ", "#{locale} yoda quotes", Faker::Quote.yoda }
    50.times { include_examples "gibberish detection for additional phrases of ", "#{locale} addresses", Faker::Address.full_address } 
    50.times { include_examples "gibberish detection for additional phrases of ", "#{locale} names", Faker::Name.name } 
    50.times { include_examples "gibberish detection for additional phrases of ", "#{locale} phone numbers", Faker::PhoneNumber.phone_number } 
    50.times { include_examples "gibberish detection for additional phrases of ", "#{locale} emails", Faker::Internet.email } 
    50.times { include_examples "gibberish detection for additional phrases of ", "#{locale} domain names", Faker::Internet.domain_name } 
    50.times { include_examples "gibberish detection for additional phrases of ", "#{locale} usernames", Faker::Internet.username } 
    50.times { include_examples "gibberish detection for additional phrases of ", "#{locale} urls", Faker::Internet.url } 
    50.times { include_examples "gibberish detection for additional phrases of ", "#{locale} company names", Faker::Company.bs } 
    50.times { include_examples "gibberish detection for additional phrases of ", "#{locale} book titles", Faker::Book.title } 
    50.times { include_examples "gibberish detection for additional phrases of ", "#{locale} famous", Faker::Quote.famous_last_words}

    # A lot of absent translation data
    # 50.times { include_examples "gibberish detection for additional phrases of ", "airport names", Faker::Travel::Airport.name(size: ['large'], region: ['united_states'].sample(1)) } 
    # 50.times { include_examples "gibberish detection for additional phrases of ", "train stations", Faker::Travel::TrainStation.name(type: 'railway') } 
  end
end