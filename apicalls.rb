TWEETAPPKEY = "hGuIGM9vFCTtVm4DmPCX9RF3E"
TWEETAPPSECRET = "jxFAyFQNYLW24jmKFO1YkgpBW8XwzH4337XymUEGtf7zxZYiFb"
TWEETTOKEN = "2604285230-AV99szaeXcEkDxtmpTExERHGmwNmq3DmWraPqF5"
TWEETTOKENSECRET = "i6gfbMymtyAiU1PeOK5A7UYx58ts5sExsON8SmsPADRGQ"

require 'twitter'
require 'pry'

class Queryier

  attr_reader :terms

  def initialize(term1, term2)
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = TWEETAPPKEY
      config.consumer_secret = TWEETAPPSECRET
      config.access_token = TWEETTOKEN
      config.access_token_secret = TWEETTOKENSECRET
    end

    @terms = [Term.new(term1, @client), Term.new(term2, @client)]
  end

  def compare
    if popular_words?
      winner = more_frequent
      return winner.frequency
    else
      winner = most_mentioned
      loser  = terms.detect {|term| term != winner } 
      return "#{winner.content.capitalize} has been mentioned #{winner.length} times in the past week!
      But #{loser.content} has only been mentioned #{winner.length} times."
    end
  end

  def popular_words?
    terms.all? { |term| term.length == 100 }
  end

  def more_frequent    
    terms.min_by do |term|
      Time.parse(term.response.first[:current_time]) - 
      Time.parse(term.response.last[:current_time])
    end
  end

  def most_mentioned
    terms.max_by { |term| term.length }
  end



end

puts Queryier.new("fuck","shit").compare


#If results of one of them is less than 100:
# _ people tweeted about _ in the past week
#If results of both is greater than 100:
#200 people tweet the word fuck every second



