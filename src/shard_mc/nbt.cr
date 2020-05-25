require "gzip"
require "./nbt/*"

module ShardMC::NBT
  VERSION = 19133
  
  def self.parse(path : String)
    Gzip::Reader.open(File.new(path)) do |gzip|
      Parser.new(gzip).parse
    end
  end
end
