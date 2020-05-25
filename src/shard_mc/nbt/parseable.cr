module ShardMC::NBT::Parseable
  def tag : Parser::Tag
    Parser::Tag.from_type(self.class)
  end
end

abstract struct Int8
  include ShardMC::NBT::Parseable
end

abstract struct Int16
  include ShardMC::NBT::Parseable
end

abstract struct Int32
  include ShardMC::NBT::Parseable
end

abstract struct Int64
  include ShardMC::NBT::Parseable
end

abstract struct Float32
  include ShardMC::NBT::Parseable
end

abstract struct Float64
  include ShardMC::NBT::Parseable
end

class String
  include ShardMC::NBT::Parseable
end
