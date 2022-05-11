# frozen_string_literal: true

require_relative "todo2/version"
require_relative "todo2/command"
require_relative "todo2/db"
require_relative "todo2/task"
require_relative "todo2/command/options"

module Todo2
  class Error < StandardError; end
  # Your code goes here...
end
