module Todo2
  class Task < ActiveRecord::Base
    
    NOT_YET = 0
    DONE = 1
    PENDING = 2

    STATUS = {
      'NOT YET' => NOT_YET,
      'DONE' => DONE,
      'PENDING' => PENDING
      }.freeze
  end
end