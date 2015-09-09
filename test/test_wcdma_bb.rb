require 'minitest/autorun'
require 'wcdma_bb'
require 'wcdma_bb/acronym'

class WcdmaBbTest < Minitest::Test
    def test_hi
        assert_equal "Hello world!", WcdmaBb.hi
    end
end

class AcronymTest < Minitest::Test
    def test_add
        Acronym.add('DPDCH', 'Dedicated Physical Data Channel')
        #assert_equal 'Dedicated Physical Data Channel', Acronym.acronyms['DPDCH']
    end

    def test_search_acronym
        Acronym.add('DPCCH', 'Dedicated Physical Control Channel')
        Acronym.add('DPDCH', 'Dedicated Physical Data Channel')
        assert_equal Hash['DPCCH', ['Dedicated Physical Control Channel']], Acronym.search_acronym('DPCCH')
        assert_equal Hash['DPCCH', ['Dedicated Physical Control Channel'], 'DPDCH', ['Dedicated Physical Data Channel']],
                        Acronym.search_acronym("DP.*")
    end
end

class UplinkDPCCHTest < Minitest::Test
    def test_k
        assert_equal 0, UplinkDPCCH.new.k
    end
    def test_N__data
        assert_equal 10, UplinkDPCCH.new.N__data
    end
end