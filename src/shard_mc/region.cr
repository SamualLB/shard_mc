require "zlib"

class ShardMC::Region
  def initialize(@io : IO)
  end

  def initialize(path : String)
    @io = File.new(path)
  end

  # Chunk data
  def [](x : Int, z : Int)
    p "============="
    location_offset = 4 * ((x % 32) + (z % 32) * 32)
    @io.pos = location_offset
    location_4 = @io.read_bytes(UInt32, IO::ByteFormat::BigEndian)
    return nil if location_4 == 0
    p chunk_offset = (location_4 & 0xFFFFFF00) >> 8
    p chunk_sectors = (location_4 & 0xFF)
    @io.pos = location_offset + 4096
    p timestamp = @io.read_bytes(Int32, IO::ByteFormat::BigEndian)
    @io.pos = chunk_offset * 4096
    p data_length = @io.read_bytes(UInt32, IO::ByteFormat::BigEndian)
    p compression_type = @io.read_bytes(UInt8, IO::ByteFormat::BigEndian)
    sized = IO::Sized.new(@io, data_length-1)
    case compression_type
    when 1 then raise "unknown compression type"
    when 2
      Zlib::Reader.open(sized) do |zlib|
        p NBT::Parser.new(zlib).parse
      end
    end
  end
end
