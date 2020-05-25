private def result
  root = ShardMC::NBT::Compound.new
  empty = ShardMC::NBT::Compound.new
  data = ShardMC::NBT::Compound.new
  data["Raids"] = ShardMC::NBT::List.new
  data["NextAvailableID"] = 1
  data["Tick"] = 1676
  empty["data"] = data
  empty["DataVersion"] = 2230
  root[""] = empty
  root
end

describe ShardMC::NBT do
  describe "#parse" do
    it "parses a valid NBT file" do
      ShardMC::NBT.parse("./spec/data/raids.dat").should eq result
    end
  end

  describe ShardMC::NBT::Serializable do
    describe "#to_nbt" do
      it "converts Int8" do
        1_i8.to_nbt.should eq "\u{1}"
      end

      it "converts Int16" do
        2_i16.to_nbt.should eq "\u{0}\u{2}"
      end

      it "converts Int32" do
        3_i32.to_nbt.should eq "\u{0}\u{0}\u{0}\u{3}"
      end

      it "converts Int64" do
        4_i64.to_nbt.should eq "\u{0}\u{0}\u{0}\u{0}\u{0}\u{0}\u{0}\u{4}"
      end

      it "converts Float32" do
        1.0_f32.to_nbt.should eq "?\x80\u{0}\u{0}"
      end

      it "converts Float64" do
        2.0_f64.to_nbt.should eq "@\u{0}\u{0}\u{0}\u{0}\u{0}\u{0}\u{0}"
      end

      it "converts String" do
        "test string".to_nbt.should eq 11_i16.to_nbt + "\x74\x65\x73\x74\x20\x73\x74\x72\x69\x6e\x67"
      end

      it "converts NBT::List containing Int8" do
        list = ShardMC::NBT::List.new
        list << 1_i8
        list << 2_i8
        list << 3_i8
        list.to_nbt.should eq 1_i8.to_nbt + 3_i32.to_nbt + 1_i8.to_nbt + 2_i8.to_nbt + 3_i8.to_nbt
      end

      it "converts NBT::List containing Int64" do
        list = ShardMC::NBT::List.new
        list << 1_i64
        list << 2_i64
        list << 3_i64
        list.to_nbt.should eq 4_i8.to_nbt + 3_i32.to_nbt + 1_i64.to_nbt + 2_i64.to_nbt + 3_i64.to_nbt
      end

      it "converts NBT::Compound" do
        c = ShardMC::NBT::Compound.new
        c["test"] = 1_i8
        c["test2"] = 2_i16
        c["test3"] = 3_i32
        c["test4"] = 4_i64
        c.to_nbt.should eq 1_i8.to_nbt + "test".to_nbt + 1_i8.to_nbt + 2_i8.to_nbt + "test2".to_nbt + 2_i16.to_nbt + 3_i8.to_nbt + "test3".to_nbt + 3_i32.to_nbt + 4_i8.to_nbt + "test4".to_nbt + 4_i64.to_nbt + 0_i8.to_nbt
      end
    end
  end
end
