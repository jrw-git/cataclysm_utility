require "./lib/cataclysm_utility/ui.rb"
require "./lib/cataclysm_utility/cataclysm_manager"
require "test/unit"

class TestUI < Test::Unit::TestCase

  def test_display_and_log
    File.delete(UI::LOG_FILENAME) if File.exist?(UI::LOG_FILENAME)
    time_of_logging_start = Time.now
    UI.display("TestUnit: Test One Two Three", true)
    time_of_logging = Time.now
    log_file = File.open(UI::LOG_FILENAME, 'r')
    log_data = log_file.readline.chomp
    assert_equal("#{time_of_logging_start}: TestUnit: Test One Two Three",log_data)
    assert_equal("#{time_of_logging}: TestUnit: Test One Two Three",log_data)
    log_file.close
  end


end
