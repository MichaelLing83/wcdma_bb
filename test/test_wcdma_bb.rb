require 'minitest/autorun'
require 'wcdma_bb'

class WcdmaBbTest < Minitest::Test
    def test_hi
        assert_equal "Hello world!", WcdmaBb.hi
    end
end