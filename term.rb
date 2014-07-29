class Term

  attr_accessors :last_tweeted, :first_tweeted, :frequency

  def initialize(content)
    @content = content
  end

end