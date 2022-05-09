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

      # def status_is(status)
      #   # ステータス=statusのレコードを返す
      #   self.where(status: status)
      # end

      # 通常のメソッド定義では、ActiveRecordRelationに接続できないため、scopeを用いて定義する
      scope :status_is, ->(status) { where(status: status )}
  end
end