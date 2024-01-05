class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def shout(str)
    liner = "•••••••••••••••••"
    puts liner
    puts str
    puts liner
  end

  def generate_token(obj, time = (Time.now + 3.hours))
    secret = ENV.fetch('SECRET_KEY_BASE', nil)
    @token = JWT.encode({
                          id: obj.id,
                          type: obj.class.to_s,
                          exp: time.to_i
                        }, secret)
  end
end
