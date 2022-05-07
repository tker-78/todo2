require 'fileutils'
require 'active_record'

module Todo2
  module DB
    def self.prepare
      # データベースのpathを設定
      database_path = File.join(ENV['HOME'], ".todo2", "todo2.sqlite3")

      # データベースと接続
      connect_database database_path
      
      # データベースが存在しない場合は、データベースを新規作成
      create_table_if_not_exists database_path
    end

    def self.connect_database(path)
      # データベースと接続
      spec = { adapter: 'sqlite3', database: path }
      ActiveRecord::Base.establish_connection spec
    end
    
    # テーブルが存在しない場合、テーブルを作成する
    def self.create_table_if_not_exists(path)
      # フォルダ階層を作成する
      create_database_path path
      
      # データベースに接続する
      connection = ActiveRecord::Base.connection
      # tasksのデータソースが存在する場合、trueを返してスコープを抜ける
      return if connection.data_source_exists?(:tasks)

      # tasksのデータソースが存在しない場合、新たにtasksテーブルを作成する
      connection.create_table :tasks do |t|
        t.column :name, :string, null: false
        t.column :content, :text, null: false
        t.column :status, :integer, default: 0, null: false
        t.timestamps
      end
      # 頻繁に呼び出すソート条件は、indexを付与しておく
      connection.add_index :tasks, :status
      connection.add_index :tasks, :created_at
      
    end
  
    def self.create_database_path(path)
      # databese_pathの最終階層までのフォルダ階層を作成する
      FileUtils.mkdir_p File.dirname(path)
    end

    private_class_method :connect_database, :create_table_if_not_exists, :create_database_path
  end
end