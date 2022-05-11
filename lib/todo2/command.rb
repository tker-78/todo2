module Todo2
  class Command

    # commandオブジェクトを生成して、実行する
    def self.run(argv)
      new(argv).execute
    end

    def initialize(argv)
      @argv = argv
    end

    def execute
      # コマンドライン引数から解析した, optionsをハッシュ形式で返す
      options = Options.parse!(@argv)
      # サブパーサーとして認識される引数を取り出す
      sub_command = options.delete(:command)

      DB.prepare

      tasks = case sub_command
        when 'create'
          create_task(options[:name], options[:content])
        when 'update'
          update_task(options[:id], options)
        when 'list'
          show_tasks(options[:status])
        when 'delete'
          delete_task(options[:id])
      end

      # 成形した状態での表示をする
      display_tasks tasks

    end

    #---------------各アクションの記述------------------#
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
      # メソッドの返り値としてtaskを返す
      return task
    end

    # show action
    def show_tasks(status_name)
      # データベースから作成日の降順で全レコードを取り出す
      all_tasks = Task.order('created_at DESC')
      
      # 引数にstatus_nameが渡された場合、該当する数値をTask::STATUSから参照する
      if status_name
        status = Task::STATUS.fetch(status_name.upcase)
        # ステータス=statusのレコードを抽出する
        all_tasks.status_is(status)
      else
        all_tasks
      end
    end

    #------------アクションの記述ここまで------------------#


    private

    def display_tasks(tasks)
      # tasksを見やすく表示する
      # headerの表示
      header = ['ID'.rjust(4), 'Name'.ljust(20), 'Content'.ljust(38), 'Status'.ljust(8)].join(' | ')
      puts header
      puts '-' * header.size

      Array(tasks).each do |task|
        puts [task.id.to_s.rjust(4), task.name.ljust(20), task.content.ljust(38), task.status_name.ljust(8)].join(' | ')
      end
      
    end
  end
end