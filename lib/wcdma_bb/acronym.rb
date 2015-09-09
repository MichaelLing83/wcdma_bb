
# Collect, hold, and look up all acronyms
# @author Michael Duo Ling
class Acronym

    # a hash containing all acronyms: string => array of strings
    @@acronyms = Hash.new

    # Store acronym => fullname pair
    # @param acronym [String] the abbreviation
    # @param fullname [String] the full name
    # @return [nil] nothing
    def self.add(acronym, fullname)
        values = @@acronyms.fetch(acronym, Array.new)
        if not values.include?(fullname)
            values << fullname
            @@acronyms[acronym] = values
        end
    end

    # Look up for one acronym pattern
    # @param pattern [String] acronym pattern (regex)
    # @return [Hash] acronym => array of fullnames for all acronyms that match given pattern
    def self.search_acronym(pattern)
        result = Hash.new
        pattern = Regexp.new(pattern)
        @@acronyms.each { |key, value|
            if pattern.match(key)
                result[key] = value
            end
        }
        return result
    end

    # Clear all saved acronyms
    # @return [nil] nothing
    def self.clear()
        @@acronyms = Hash.new
    end
end