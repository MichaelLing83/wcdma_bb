require 'wcdma_bb/acronym'
require 'enum'

# 4 Services offered to higher layers
# 4.1 Transport channels
Acronym.add('DCH',      'Dedicated Channel')
Acronym.add('E-DCH',    'Enhanced Dedicated Channel')
Acronym.add('BCH',      'Broadcast Channel')
Acronym.add('FACH',     'Forward Access Channel')
Acronym.add('PCH',      'Paging Channel')
Acronym.add('RACH',     'Random Access Channel')
Acronym.add('HS-DSCH',  'High Speed Downlink Shared Channel')

# 4.2 Indicators
Acronym.add('AI',       'Acquisition Indicator')
Acronym.add('PI',       'Page Indicator')
Acronym.add('NI',       'MBMS Notification Indicator')
Acronym.add('ICH',      'Indicator Channel')

# 5 Physical channels and physical signals
Acronym.add('CCTrCH',   'Composite Coded Transport Channel')

# number of chips in one radio frame
RADIO_FRAME_LENGTH_IN_CHIPS = 38400
# number of chips in one slot
SLOT_LENGTH_IN_CHIPS        = 2560
# number of chips in one subframe
SUBFRAME_LENGTH_IN_CHIPS    = 7680

# 5.1 Physical signals

# 5.2 Uplink physical channels
# 5.2.1 Dedicated uplink physical channels
Acronym.add('DPDCH',        'Dedicated Physical Data Channel')
Acronym.add('DPCCH',        'Dedicated Physical Control Channel')
Acronym.add('E-DPDCH',      'E-DCH Dedicated Physical Data Channel')
Acronym.add('E-DPCCH',      'E-DCH Dedicated Physical Control Channel')
Acronym.add('HS-DPCCH',     'Dedicated Control Channel associated with HS-DSCH transmission')

# types of uplink dedicated physical channels
UL_DEDICATED_PHY_CHANNEL_LIST   = ["DPDCH", "DPCCH", "E-DPDCH", "E-DPCCH", "HS-DPCCH"]

Acronym.add('TPC',      'Transmit Power-Control')
Acronym.add('TFCI',     'Transport-Format Combination Indicator')
Acronym.add('FBI',      'Feedback Information')

# 5.2.1.1 DPCCH and DPDCH

# length of one slot in chips
T__slot = SLOT_LENGTH_IN_CHIPS

Acronym.add('SF',   'Spreading Factor')

# Base class for all physical channels
class PhysicalChannel

    # Calc perameter k
    # @param sf [Integer] spreading factor
    # @param max_sf [Integer] maximum SF, e.g. 4 for DPDCH
    # @param min_sf [Integer] minimum SF, e.g. 256 for DPDCH
    # @return [Integer] k, parameter k that determines the number of bits per slot
    def self.k(sf:, max_sf:, min_sf:)
        raise 'SF=%s is out of range ([%s..%s])' % [sf, max_sf, min_sf] if not sf.between?(max_sf, min_sf)
        return Math.log2(256/sf).to_i
    end

    # Calc number of bits per slot
    # @param k [Integer]
    # @return [Integer] number of bits per slot
    def self.N__data(k:)
        return 10 * (2 ** k)
    end
end

# Uplink DPDCH slot formats
UplinkDpdchSlotFormatEnum = Enum.new(:UL_DPDCH_slot_format_0,
                                    :UL_DPDCH_slot_format_1,
                                    :UL_DPDCH_slot_format_2,
                                    :UL_DPDCH_slot_format_3,
                                    :UL_DPDCH_slot_format_4,
                                    :UL_DPDCH_slot_format_5,
                                    :UL_DPDCH_slot_format_6)

class UplinkDPDCH < PhysicalChannel
    @@DPDCH_MIN_SF_FACTOR = 256
    @@DPDCH_MAX_SF_FACTOR = 4

    attr_reader :sf, :k, :N__data, :slot_format, :kbps, :ksps, :bit_per_slot, :bit_per_frame

    # Create a new instance
    # @param slot_format [symbol] slot format from table 1 25.211 v10.0
    # @return [UplinkDPDCH] a new instance of this class
    def initialize(slot_format:)
        raise "slot_format=%s is out of range [0..6]" % slot_format if not UplinkDpdchSlotFormatEnum.has_value?(slot_format)
        @slot_format = slot_format
        @sf = 256 / (2**UplinkDpdchSlotFormatEnum[@slot_format])
        @k  = self.class.k(sf: @sf, max_sf: @@DPDCH_MAX_SF_FACTOR, min_sf: @@DPDCH_MIN_SF_FACTOR)
        @N__data = self.class.N__data(k: @k)
        @bit_per_slot = @N__data
        @bit_per_frame = @bit_per_slot * RADIO_FRAME_LENGTH_IN_CHIPS / SLOT_LENGTH_IN_CHIPS
        @kbps = @bit_per_frame / 10
        @ksps = @kbps
    end
end

# Uplink DPCCH slot formats
:UL_DPCCH_slot_format_0
:UL_DPCCH_slot_format_0A
:UL_DPCCH_slot_format_0B
:UL_DPCCH_slot_format_1
:UL_DPCCH_slot_format_2
:UL_DPCCH_slot_format_2A
:UL_DPCCH_slot_format_2B
:UL_DPCCH_slot_format_3
:UL_DPCCH_slot_format_4

# Uplink DPCCH slot formats
UplinkDpcchSlotFormatEnum = Enum.new(:UL_DPCCH_slot_format_0,
                                    :UL_DPCCH_slot_format_0A,
                                    :UL_DPCCH_slot_format_0B,
                                    :UL_DPCCH_slot_format_1,
                                    :UL_DPCCH_slot_format_2,
                                    :UL_DPCCH_slot_format_2A,
                                    :UL_DPCCH_slot_format_2B,
                                    :UL_DPCCH_slot_format_3,
                                    :UL_DPCCH_slot_format_4)

Acronym.add('FSW',  "Frame Synchronization Word")

class UplinkDPCCH < PhysicalChannel
    @@SF = 256

    attr_reader :slot_format, :sf, :k, :kbps, :ksps, :bit_per_frame,
                :bit_per_slot, :N__pilot, :N__TPC, :N__TFCI, :N__FBI

    # Create a new instance
    # @param slot_format [symbol] slot format from table 2 25.211 v10.0
    # @return [UplinkDPDCH] a new instance of this class
    def initialize(slot_format:)
        @slot_format = slot_format
        @sf = @@SF
        @k  = self.class.k(sf: @sf, max_sf: @@SF, min_sf: @@SF)
        @kbps = 15
        @ksps = 15
        @bit_per_frame = 150
        @bit_per_slot = 10
        @N__pilot = [6,5,4,8,5,4,3,7,6][UplinkDpcchSlotFormatEnum[@slot_format]]
        @N__TPC   = [2,2,2,2,2,2,2,2,4][UplinkDpcchSlotFormatEnum[@slot_format]]
        @N__TFCI  = [2,3,4,0,2,3,4,0,0][UplinkDpcchSlotFormatEnum[@slot_format]]
        @N__FBI   = [0,0,0,0,1,1,1,1,0][UplinkDpcchSlotFormatEnum[@slot_format]]
    end
end