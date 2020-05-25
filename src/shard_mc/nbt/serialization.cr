module ShardMC::NBT::Serializable
  def to_nbt : String
    String.build do |s|
      to_nbt(s)
    end
  end

  abstract def to_nbt(io : IO)
end

abstract struct Int
  include ShardMC::NBT::Serializable

  def to_nbt(io)
    to_io(io, IO::ByteFormat::BigEndian)
  end
end

abstract struct Float
  include ShardMC::NBT::Serializable

  def to_nbt(io)
    to_io(io, IO::ByteFormat::BigEndian)
  end
end


class String
  include ShardMC::NBT::Serializable

  def to_nbt(io)
    bytesize.to_i16.to_io(io, IO::ByteFormat::BigEndian)
    bytes.each &.to_io(io, IO::ByteFormat::BigEndian)
  end
end

class ShardMC::NBT::List
  include ShardMC::NBT::Serializable

  def to_nbt(io)
    actual_type.value.to_i8.to_io(io, IO::ByteFormat::BigEndian)
    size.to_io(io, IO::ByteFormat::BigEndian)
    each &.to_nbt(io)
  end
end

class ShardMC::NBT::Compound
  include ShardMC::NBT::Serializable

  def to_nbt(io)
    each do |k, v|
      Parser::Tag.from_type(v.class).value.to_io(io, IO::ByteFormat::BigEndian)
      k.to_nbt(io)
      v.to_nbt(io)
    end
    0_i8.to_nbt(io)
  end
end
