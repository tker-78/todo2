module Todo2
  class Command

    def execute
      DB.prepare
    end

    # create action
    def create_task(name, content)
      Task.create!(name: name, content: content)
    end
  
    # delete action
    def delete_task(id)
      task = Task.find(id)
      task.destroy
    end

    # update action
    def update_task(id, attributes)
      # 引数にstatusを含む場合、STATUSのハッシュから値を参照して,数値を返す
      if status_name = attributes[:status]
        attributes[:status] = Task::STATUS.fetch(status_name.upcase)
      end

      task = Task.find(id)
      task.update_attributes! attributes
    end

    # show action
    def show_tasks(status_name)
      # データベースから作成日の降順で全レコードを取り出す
      all_tasks = Task.order('created_at DESC')
      
      # 引数にstatus_nameが渡された場合、該当する数値をTask::STATUSから参照する
      if status_name
        status = Task::STATUS.fetch(status_name.upcase)
        # ステータス=statusのレコードを抽出する
        all_task.status_is(status)
      else
        all_tasks
      end
    end


  end
end