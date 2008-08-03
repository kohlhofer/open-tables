class User < Goldberg::User
  has_many :items
  
  def admin?
    return role.name == 'Administrator'
  end
end
