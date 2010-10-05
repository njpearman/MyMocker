require 'cucumber/formatter/pretty'

class KoanFormatter < Cucumber::Formatter::Pretty
  def scenario_name(keyword, name, file_colon_line, source_indent)
    super
    @koan_failed = @koan_skipped = false
  end

  def step_name keyword, step_match, status, source_indent, background
    @koan_skipped = 'skipped' == status.to_s

    unless @koan_failed
      super unless @koan_skipped
      @koan_failed = ['failed', 'pending'].include? status.to_s
    end
  end
  
  def after_features features
    puts ProgressTracker.progress_message
    super
  end
end