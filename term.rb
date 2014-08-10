class Term

  attr_accessor :response, :content

  def initialize(content, client)
    @content  = content  
    @response = client.search(content).attrs[:statuses]
  end

  def length
    response.length
  end

  def results
    result = {}
    if measure_by_week?
      result[:count] = self.length 
    else
      result[:seconds] = self.time_span
    end
    return result
  end

  def measure_by_week?
    (self.length < 90 || unpopular_tweet?) ? true : false
  end

  def unpopular_tweet?
    if self.length > 0
      return time_span > 8_640_000 ? true : false
    end
    return true
  end

  def stats
    if self.results[:count]
      return self.count_frequency
    else
      self.frequency
    end
  end

  def count_frequency
    if self.length < 7
      return {num: self.length, unit: :week}
    else
      return {num: (round_ratio(self.length.to_f / 7)), unit: :day}
    end
  end

  def frequency
    #seconds
    if time_span == 0
      return {num: 101, unit: :second} 

    elsif time_span <= 100
      ratio = tweets_over_time
      return {num: round_ratio(ratio), unit: :second}
  

    #minutes
    elsif time_span <= 6000
      ratio = tweets_over_time(60)
      return {num: round_ratio(ratio), unit: :minute}
    
    #hours
    elsif time_span <= 360000
      ratio = tweets_over_time(3600)
      return {num: round_ratio(ratio), unit: :hour}
    
    

    #days, NEVER HAPPENS THO
    elsif time_span <= 8640000
      ratio = tweets_over_time(86_400)
      return {num: round_ratio(ratio), unit: :day}
    
    end

  end

  def tweets_over_time(exponant = 1)
    (self.length.to_f / time_span) * exponant   
  end 

  def time_span
    Time.parse(self.response.first[:created_at]) - 
    Time.parse(self.response.last[:created_at])
  end

  def round_ratio(ratio)
    ratio = ratio == ratio.to_i ? ratio.to_i : ratio.round(2) 
  end



end