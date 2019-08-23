
module UsersHelper
  def options_for_seasons
    [['Male', 'male'], ['Female', 'female']]
  end

  def age(dob)
    now = Time.now.utc.to_date
    now.year - dob.year
  end

  def is_current_user?(user)
    user == current_user
  end
end
