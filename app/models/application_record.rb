class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def shout(str)
    puts "############ #{str} ############"
  end
end
