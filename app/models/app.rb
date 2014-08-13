require 'twitter'
require 'pry'
require 'time'

require_relative './term'

# a winning tweet's data
# querier.winner.response.shuffle.first[:user]
# querier.winner.response.shuffle.first[:user][:screen_name]
# querier.winner.response.shuffle.first[:text]

# q.winner.stats => {:num=>41.38, :unit=>:minute}
# q.winner.content => "term"

class Queryier

  attr_reader :terms, :winner, :loser

  def initialize(term1, term2)
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWEETAPPKEY']
      config.consumer_secret = ENV['TWEETAPPSECRET']
      config.access_token = ENV['TWEETTOKEN']
      config.access_token_secret = ENV['TWEETTOKENSECRET']
    end

    @terms = [Term.new(term1, @client), Term.new(term2, @client)]
    self.compare
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
  end

  def count_winner_loser
    terms.sort_by(&:length).reverse
  end

  def most_mentioned
    terms.max_by(&:length)
  end

  def random_winner_tweet
    random_tweet = self.winner.response.sample
    if random_tweet[:user][:lang] == "en" || !(random_tweet[:text].include?(self.winner.content))
      return {screen_name: "@#{random_tweet[:user][:screen_name]}", text: random_tweet[:text]}
    else
      self.random_winner_tweet
    end
  end

end

# puts "please enter words"
# q = Queryier.new(gets.chomp, gets.chomp)
# q.compare
# puts "Winner: #{q.winner.content} at #{q.winner.stats}"
# puts "Loser: #{q.loser.content} at #{q.loser.stats}"
# puts "Suggestions for next time: #{Term.suggestions.shuffle[0,2]}"






