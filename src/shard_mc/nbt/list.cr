class ShardMC::NBT::List < Array(ShardMC::NBT::Parseable)
  include Parseable

  getter! actual_type : Parser::Tag

  def initialize(@actual_type : Parser::Tag)
  end

  def initialize(klass : Class)
    @actual_type = Parser::Tag.from_type(klass)
  end

  def initialize
  end

  def initialize(size)
    super
  end

  private def check_type(value)
    if @actual_type.nil?
      @actual_type = Parser::Tag.from_type(value.class)
    else
      raise "Incorrect type (#{value.class}), (#{actual_type})" unless Parser::Tag.from_type(value.class) == actual_type
    end
  end

  def []=(index : Int, value : ShardMC::NBT::Parseable)
    check_type(value)
    super
  end

  def push(value : ShardMC::NBT::Parseable)
    check_type(value)
    super
  end

  def <<(value : ShardMC::NBT::Parseable)
    check_type(value)
    super
  end
end
