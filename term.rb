class Term

  attr_accessors :response

  def initialize(content, client)
    @content  = content
    @response = client.search(content).attrs[:statuses]
  end

  def length
    response.length
  end

  # bad idea to create the string here???
  def frequency
    if seconds_per_hundred_tweets < 100
      ratio = 100 / seconds_per_hundred_tweets
      return "#{content} is tweeted #{round_ratio(ratio)} times per second"
    else
      ratio = ( 100 / seconds_per_hundred_tweets) * 60
      return "#{content} is tweeted #{round_ratio(ratio)} times per minute"
    end
  end

  def seconds_per_hundred_tweets
    Time.parse(term.first[:current_time]) - 
    Time.parse(term.last[:current_time])
  end

  def round_ratio(ratio)
    ratio = ratio == ratio.to_i ? ratio.to_i : ratio.round(2) 
    return ratio
  end



end