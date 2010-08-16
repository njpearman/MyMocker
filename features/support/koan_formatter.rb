require 'cucumber/formatter/pretty'

class KoanFormatter < Cucumber::Formatter::Pretty
  def koan_failed?
    @koan_failed
  end

  def scenario_name(keyword, name, file_colon_line, source_indent)
    super
    @koan_failed = false
  end

  def step_name keyword, step_match, status, source_indent, background
    unless @koan_failed
      super
      @koan_failed = ['failed', 'pending'].include? status.to_s
    end
  end
end