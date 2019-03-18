# frozen_string_literal: true

require 'zeitwerk'


class CustomInflector < Zeitwerk::Inflector
  def camelize(basename, _abspath)
    case basename
    when 'ui'
      'UI'
    when 'cli'
      'CLI'
    else
      super
    end
  end
end

loader = Zeitwerk::Loader.new
loader.push_dir(__dir__ + '/../lib/')
loader.push_dir(__dir__ + '/test_doubles/')
loader.inflector = CustomInflector.new
loader.setup
