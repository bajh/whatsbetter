TWEETAPPKEY = "hGuIGM9vFCTtVm4DmPCX9RF3E"
TWEETAPPSECRET = "jxFAyFQNYLW24jmKFO1YkgpBW8XwzH4337XymUEGtf7zxZYiFb"
TWEETTOKEN = "2604285230-AV99szaeXcEkDxtmpTExERHGmwNmq3DmWraPqF5"
TWEETTOKENSECRET = "i6gfbMymtyAiU1PeOK5A7UYx58ts5sExsON8SmsPADRGQ"

require 'twitter'
require 'pry'
require 'time'

require_relative './term'

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

  # determine which is said more from 100 tweet sample
  # display stats for the winner and the loser

  # check if one phrase has more tweets, ie 18 vs 97, easy to determine winner
    # if both phrases are popular, get more granular in dermining, ie tweets per hundred secs




  def compare
    if popular_words?
      winner = more_frequent
      return winner.frequency
    else
      winner = most_mentioned
      loser  = terms.detect {|term| term != winner } 
      return "#{winner.frequency}"
    end
  end

  # a word tweeted 0 times will break everything.
  def popular_words?

  
      terms.all? do |term|    
        return false if term.no_tweets? 
        (term.seconds_per_hundred_tweets < 1800 && term.length > 80) || term.length == 100 
      end
  end

  def more_frequent    
    terms.min_by do |term|
      term.seconds_per_hundred_tweets
    end
  end

  def most_mentioned
    terms.max_by { |term| term.length }
  end



end

puts Queryier.new("patent", "adfhgoeooooooeoe").compare


#If results of one of them is less than 100:
# _ people tweeted about _ in the past week
#If results of both is greater than 100:
#200 people tweet the word fuck every second



