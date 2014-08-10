TWEETAPPKEY = "hGuIGM9vFCTtVm4DmPCX9RF3E"
TWEETAPPSECRET = "jxFAyFQNYLW24jmKFO1YkgpBW8XwzH4337XymUEGtf7zxZYiFb"
TWEETTOKEN = "2604285230-AV99szaeXcEkDxtmpTExERHGmwNmq3DmWraPqF5"
TWEETTOKENSECRET = "i6gfbMymtyAiU1PeOK5A7UYx58ts5sExsON8SmsPADRGQ"

require 'twitter'
require 'pry'
require 'time'

require_relative './term'

class Queryier

  attr_reader :terms, :winner, :loser

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
    if self.terms.all? { |t| t.results[:count] }
      @winner, @loser = self.count_winner_loser
    elsif self.terms.all? { |t| t.results[:seconds] }
      @winner, @loser = terms.sort_by { |t| t.results[:seconds] }
    else
      @winner = terms.select { |t| t.results[:seconds]}[0]
      @loser = terms.select { |t| t.results[:count]}[0]
    end
    
     # binding.pry
  end

  def count_winner_loser
    terms.sort_by { |t| t.length }
  end

  def most_mentioned
    terms.max_by { |term| term.length }
  end

end

puts "please enter words"
q = Queryier.new(gets.chomp, gets.chomp)
q.compare

puts "Winner: #{q.winner.content} at #{q.winner.stats}"
puts "Loser: #{q.loser.content} at #{q.loser.stats}"


