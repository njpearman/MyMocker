require 'cucumber/formatter/pretty'

class KoanFormatter
  class << self
    def set_creation &block
      @create_with = block
    end

    def create_with step_mother, path_or_io, options
      @create_with ||= lambda do |step_mother, path_or_io, options|
        Cucumber::Formatter::Pretty.new step_mother, path_or_io, options
      end
      
      @create_with.call(step_mother, path_or_io, options)
    end

    def create_decorated_formatter step_mother, path_or_io, options
      create_with(step_mother, path_or_io, options)
    end
  end

  def initialize step_mother, path_or_io, options
    @decorated_formatter = KoanFormatter.create_with step_mother, path_or_io, options
  end
  
  def koan_failed?
    @koan_failed
  end

  def step_name keyword, step_match, status, source_indent, background
    @koan_failed = status == :failed
    @decorated_formatter.step_name(keyword, step_match, status, source_indent, background)
  end

  def method_missing method_name, *args, &block
    @decorated_formatter.send(method_name, *args) &block
  end
end