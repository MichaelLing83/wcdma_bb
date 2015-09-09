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
        #Acronym.add('E-DPCCH', 'Enhanced Dedicated Physical Control Channel')
        #Acronym.add('E-DPDCH', 'Enhanced Dedicated Physical Data Channel')
        assert_equal Hash['E-DPCCH', ['E-DCH Dedicated Physical Control Channel']], Acronym.search_acronym('E-DPCCH')
        assert_equal Hash['E-DPCCH', ['E-DCH Dedicated Physical Control Channel'], 'E-DPDCH', ['E-DCH Dedicated Physical Data Channel']],
                        Acronym.search_acronym("E-DP.CH")
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