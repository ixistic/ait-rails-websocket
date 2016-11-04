class Comment < ActiveRecord::Base

  belongs_to :article

  def pretty_date
    created_at.strftime('%b %d, %Y at %I:%M %p')
  end

end
