class Term

  attr_accessor :response, :content

  def initialize(content, client)
    @content  = content
   
    @response = client.search(content).attrs[:statuses]
  end

  def no_tweets?
    response.empty? ? true : false
  end

  def length
    response.length
  end

  # def frequency
  #   if seconds_per_hundred_tweets == 0
  #     return "#{content} is literally being tweeted hundreds of times per second! That is amazing."
  #   elsif seconds_per_hundred_tweets < 100
  #     ratio = 100.0 / seconds_per_hundred_tweets
  #     return "#{content} is tweeted #{round_ratio(ratio)} times per second"
  #   elsif seconds_per_hundred_tweets == 100
  #     return "#{content} is tweeted 1 time per second"
  #   else #seconds_per_hundred_tweets < 1000
  #     ratio = ( 100.0 / seconds_per_hundred_tweets) * 60
  #     return "#{content} is tweeted #{round_ratio(ratio)} times per minute"
  #   end

  # end

  # we need seconds from first tweet to last tweet so we can use this for all terms
  # need to figure out how to also determine winner
  def seconds_per_hundred_tweets

    Time.parse(self.response.first[:created_at]) - 
    Time.parse(self.response.last[:created_at])
  end

  def round_ratio(ratio)
    ratio = ratio == ratio.to_i ? ratio.to_i : ratio.round(2) 
    return ratio
  end



end