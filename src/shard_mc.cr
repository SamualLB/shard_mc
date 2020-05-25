require "./shard_mc/*"

module ShardMC
  VERSION = "0.0.1"
end

#region = ShardMC::Region.new("/home/sam/.minecraft/saves/New World/region/r.-1.-1.mca")
#region[0, 0]
#region[1, 0]
#region[0, 1]
#region[10, 10]

p ShardMC::NBT.parse(ARGV[0])
