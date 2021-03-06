
module ActionController
  class Base
    def current_user
      return false unless session[:goldberg]
      begin
        @current_user ||= User.find(session[:goldberg][:user_id])
      rescue ActiveRecord::RecordNotFound => ex
        return false
      end
    end
    alias :logged_in? :current_user

    def create_guest(args = {})
      return if logged_in?
      attributes = {"name" => 'guest%i' % rand(100000), 
        :clear_password => Goldberg::User.random_password,
        :role_id => Goldberg::Role.find_by_name('Guest', :select => :id).id}
      attributes.update(args) if args.is_a?(Hash)
      return if current_user
      user = User.create(attributes)
      return user if user.new_record?
      user.update_attribute :name, 'guest%i' % user.id if user.name =~ /^guest/
      
      Goldberg.user = user
      if Goldberg.settings.self_reg_confirmation_required
        if Goldberg.settings.self_reg_send_confirmation_email
          confirm_email = UserMailer.create_confirmation_request(@user)
          UserMailer.deliver(confirm_email)
        end
      end
      Goldberg::AuthController.set_user(session, user.id)
      user
    end
  end
end

module Goldberg
  class User
    validates_presence_of :email
    def is_guest?
      name =~ /^guest/
    end
  end
end