# frozen_string_literal: true

module Unicode
  class DisplayWidth
    VERSION = "2.0.0.pre1"
    UNICODE_VERSION = "13.0.0".freeze
    DATA_DIRECTORY = File.expand_path(File.dirname(__FILE__) + "/../../../data/")
    INDEX_FILENAME = DATA_DIRECTORY + "/display_width.marshal.gz"
  end
end
