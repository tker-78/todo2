require 'optparse'

module Todo2
  class Command
    class Options

      def self.parse!(argv)
        options = {}

        # OptionParserを定義する
        sub_parser = create_sub_parser(options)
        parser = create_parser

        # コマンドパーサーの解析を実行
        begin
          parser.order!(argv)
          # 与えられた引数のうち、先頭の引数をoptions[:command]に格納して、削除する
          options[:command] = argv.shift

          # sub_parserに引数を渡して解析実行
          sub_parser[options[:command]].parse!(argv)


          # updateとdeleteの場合はidを取得する
          if %w(update delete).include?(options[:command])
            raise ArgumentError, "#{options[:command]} id not found." if argv.empty?
            options[:id] = Integer(argv.first)
          end

        rescue OptionParser::MissingArgument, OptionParser::InvalidOption, ArgumentError => e
          abort e.message
        end

        # クラスメソッドの返り値として、optionsを返す
        options
      end

      def self.create_sub_parser(options)
        # サブコマンドと認識された時,optionsを解析してsub_parserをハッシュ形式で返す
        sub_parser = {}

        sub_parser['create'] = OptionParser.new do |opt|
          opt.on('-n VAL', '--name=VAL', "task name" ) { |v| options[:name] = v }
          opt.on('-c VAL', '--content=VAL', "content name" ) { |v| options[:content] = v }
        end

        sub_parser['list'] = OptionParser.new do |opt|
          opt.on('-s VAL', '--status==VAL', 'list status') { |v| options[:status] = v }
        end

        sub_parser['update'] = OptionParser.new do |opt|
          opt.on('-n VAL', '--name=VAL', 'update name') { |v| options[:name] = v }
          opt.on('-c VAL', '--content=VAL', 'update content' ) { |v| options[:content] = v }
          opt.on('-s VAL', '--content-VAL', 'update status' ) { |v| options[:status] = v }
        end

        sub_parser['delete'] = OptionParser.new do |opt|

        end

        sub_parser
      end

      def self.create_parser
        OptionParser.new do |opt|
          sub_command_help = [
            {name: 'create -n name -c content', summary: 'Create Todo Task'},
            {name: 'update id -n name -c content -s status', summary: 'Update Todo Task'},
            {name: 'list -s status', summary: 'List Todo Status'},
            {name: 'delete id', summary: 'Delete Todo Task'}
          ]

          opt.banner = "Usage: #{opt.program_name} [-h|--help][-v|--version]<command>[<args>]"
          opt.separator ''
          opt.separator "#{opt.program_name} Avairable Commands:"
          sub_command_help.each do |command|
            opt.separator [opt.summary_indent, command[:name].ljust(40), command[:summary]].join(' ')
          end

          opt.on_head('-h', '--help', 'Show this message') do |v|
            puts opt.help
            exit
          end

          opt.on_head('-v', '--version', 'Show program version') do |v|
            opt.version = Todo2::VERSION
            puts opt.ver
            exit
          end
        end
      end
      

    end
  end
end