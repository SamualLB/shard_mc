require "./parseable"

class ShardMC::NBT::ByteArray < Array(Int8)
  include Parseable
end
