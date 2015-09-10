
class Enum < Hash

    # Create a new Enum instance
    # @param *members [Array of String] list of strings becoming symbols
    # @return [Enum]
    def initialize(*members)
        super()
        @rev = {}
        members.each_with_index {|m,i| self[i] = m}
    end

    # Get index by symbol or get symbol by index
    # @param k [symbol or Integer]
    # @return [Integer or symbol]
    def [](k)
        super || @rev[k]
    end

    # Change or add enum pair
    # @param k [String] the symbol name
    # @param v [Integer] the index
    # @return [nil]
    def []=(k, v)
        @rev[v] = k
        super
    end
end