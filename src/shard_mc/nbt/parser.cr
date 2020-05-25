class ShardMC::NBT::Parser
  def initialize(@io : IO)
  end

  def parse : Compound
    parse_compound
  end

  private def parse_payload(tag : Tag) : Parseable
    case tag
    when Tag::Byte then read_bytes(Int8)
    when Tag::Short then read_bytes(Int16)
    when Tag::Int then read_bytes(Int32)
    when Tag::Long then read_bytes(Int64)
    when Tag::Float then read_bytes(Float32)
    when Tag::Double then read_bytes(Float64)
    when Tag::ByteArray then parse_byte_array
    when Tag::String then parse_string
    when Tag::List then parse_list
    when Tag::Compound then parse_compound
    when Tag::IntArray then parse_int_array
    when Tag::LongArray then parse_long_array
    else
      raise "Unimplemented! #{tag}"
    end
  end

  private def parse_tag : Tag
    Tag.new(read_bytes(Int8))
  rescue ex : IO::EOFError
    Tag::End
  end

  private def parse_byte_array
    size = read_bytes(Int32)
    arr = ByteArray.new(size)
    size.times do
      arr << read_bytes(Int8)
    end
    arr
  end

  private def parse_string : String
    str_bytes = read_bytes(Int16)
    String.new(read_bytes(Bytes.new(str_bytes)))
  end

  private def parse_list
    tag = parse_tag
    size = read_bytes(Int32)
    arr = List.new(size)
    size.times do
      arr << parse_payload(tag)
    end
    arr
  end

  private def parse_compound
    hash = Compound.new
    loop do
      tag = parse_tag
      break if tag == Tag::End
      name = parse_string
      hash[name] = parse_payload(tag)
    end
    hash
  end

  private def parse_int_array
    size = read_bytes(Int32)
    arr = IntArray.new(size)
    size.times do
      arr << read_bytes(Int32)
    end
    arr
  end

  private def parse_long_array
    size = read_bytes(Int32)
    arr = LongArray.new(size)
    size.times do
      arr << read_bytes(Int64)
    end
    arr
  end

  private def read_bytes(t)
    @io.read_bytes(t, IO::ByteFormat::BigEndian)
  end

  private def read_bytes(b : Bytes)
    read = @io.read(b)
    raise "Read error" unless read == b.size
    b
  end

  enum Tag : Int8
    End = 0
    Byte = 1
    Short = 2
    Int = 3
    Long = 4
    Float = 5
    Double = 6
    ByteArray = 7
    String = 8
    List = 9
    Compound = 10
    IntArray = 11
    LongArray = 12

    def self.from_type(t : Class) : Tag
      if t == Int8
        Byte
      elsif t == Int16
        Short
      elsif t == Int32
        Int
      elsif t == Int64
        Long
      elsif t == Float32
        Float
      elsif t == Float64
        Double
      elsif t == ::String
        String
      elsif t == NBT::List
        List
      elsif t == NBT::Compound
        Compound
      else
        raise "Unimplemented type #{t}"
      end
    end
  end
end
