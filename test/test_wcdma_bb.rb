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

class UplinkDPDCHTest < Minitest::Test
    def test_init
        UplinkDpdchSlotFormatEnum.values.each { |slot_format|
            uplinkDpdch = UplinkDPDCH.new(slot_format: slot_format)
            # convert to corresponding Integer
            slot_format = UplinkDpdchSlotFormatEnum[slot_format]
            assert_equal 10 * (2**slot_format), uplinkDpdch.N__data
            assert_equal 15 * (2**slot_format), uplinkDpdch.kbps
            assert_equal 15 * (2**slot_format), uplinkDpdch.ksps
            assert_equal 256 / (2**slot_format), uplinkDpdch.sf
            assert_equal 150 * (2**slot_format), uplinkDpdch.bit_per_frame
            assert_equal 10 * (2**slot_format), uplinkDpdch.bit_per_slot
        }

    end
end

class UplinkDPCCHTest < Minitest::Test
    def test_init
        UplinkDpcchSlotFormatEnum.values.each { |slot_format|
            uplinkDpcch = UplinkDPCCH.new(slot_format: slot_format)
            assert_equal 15, uplinkDpcch.kbps
            assert_equal 15, uplinkDpcch.ksps
            assert_equal 256, uplinkDpcch.sf
            assert_equal 150, uplinkDpcch.bit_per_frame
            assert_equal 10, uplinkDpcch.bit_per_slot
            assert_equal 10, uplinkDpcch.N__pilot + uplinkDpcch.N__TPC +
                                uplinkDpcch.N__TFCI + uplinkDpcch.N__FBI
        }

    end
end