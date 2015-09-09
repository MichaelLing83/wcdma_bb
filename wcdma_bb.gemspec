Gem::Specification.new do |s|
    s.name          = 'wcdma_bb'
    s.version       = '0.0.2'
    s.executables   << 'wcdma_bb'
    s.date          = '2015-09-09'
    s.summary       = 'WCDMA baseband in Ruby'
    s.description   = "WCDMA baseband algorithm implementation in Ruby, as a learning material."
    s.authors       = ["Michael Duo Ling"]
    s.email         = 'duo.ling.cn@gmail.com'
    s.homepage      = 'http://rubygems.org/gems/wcdma_bb'
    s.license       = 'MIT'
    s.files         = ["lib/wcdma_bb.rb",
                       "lib/wcdma_bb/acronym.rb",
                       "lib/wcdma_bb/rel10/ts25_211.rb"]
end