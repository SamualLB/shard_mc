require "./parseable"

class ShardMC::NBT::Compound < Hash(String, ShardMC::NBT::Parseable)
  include Parseable
end
