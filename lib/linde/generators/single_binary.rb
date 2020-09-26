require_relative 'inc_gen'
require_relative 'relation'

# This constructs a single binary join between relations R and S.
# It can be customized in the following dimensions:
#
#   r_tuples:     number of tuples of relation R to be generated per second
#   s_tuples:     number of tuples of relation S to be generated per second
#   join_tuples:  number of tuples in the join result per second
#   seconds:      number of consecutive seconds to be generated
class SingleBinary
  attr_accessor :r_tuples, :s_tuples, :join_tuples, :seconds, :starting_timestamp

  def initialize
    @r_tuples = 10
    @s_tuples = 10
    @join_tuples = 10
    @seconds = 1
    @starting_timestamp = 0
  end

  def tick ts_offset, key_offset
    puts '## scenario'
    puts "r_tuples: #{@r_tuples}"
    puts "s_tuples: #{@s_tuples}"
    puts "join_tuples: #{@join_tuples}"
    puts '## preparing for r:'
    puts "r_tuples_ts_increment: #{r_tuples_ts_increment}"
    puts "r_step_size: #{r_step_size}"
    puts '## preparing for s:'
    puts "s_tuples_ts_increment: #{r_tuples_ts_increment}"
    puts "s_step_size: #{r_step_size}"


    r_gen = IncGen.new ts_offset, r_tuples_ts_increment, key_offset, r_step_size
    s_gen = IncGen.new ts_offset, s_tuples_ts_increment, key_offset, s_step_size

    rel_r = Relation.new :rid, :x
    # rel_r = []
    @r_tuples.times do
      rel_r << r_gen.next
    end

    rel_s = Relation.new :sid, :x
    # rel_s = []
    @s_tuples.times do
      rel_s << s_gen.next
    end

    [rel_r, rel_s]
  end


  # This method takes a block
  # and repeatedly calls that block with two arguments, rel_r and rel_s.
  #
  # For example:
  # 
  # ```ruby
  # gen = SingleBinary.new
  # gen.generate do |r, s|
  #   puts "R: #{r}"
  #   puts "S: #{s}"
  # end
  # ```
  def generate &block
    @seconds.times do |x|
      current_ts_offset = @starting_timestamp + x * 1000
      current_key_offset = x * base_key_offset
      rel_r, rel_s = tick current_ts_offset, current_key_offset
      yield rel_r, rel_s
    end
  end

  private

  # How much do two consecutive timestamps of R differ?
  def r_tuples_ts_increment
    1000.0 / @r_tuples
  end

  # How much do two consecutive timestamps of S differ?
  def s_tuples_ts_increment
    1000.0 / @s_tuples
  end

  def selectivity_per_second
    @join_tuples.to_f / (@r_tuples.to_f * @s_tuples.to_f)
  end

  def r_step_size
    if 1 >= selectivity_per_second * @s_tuples
      (1.0 / selectivity_per_second) * (1.0 / @r_tuples.to_f)
    else
      (1.0 / selectivity_per_second) * (1.0 / @r_tuples.to_f)
    end
  end

  def s_step_size
    if 1 >= selectivity_per_second * @s_tuples
      1
    else
      (1.0 / selectivity_per_second) * (1.0 / @s_tuples.to_f)
    end
  end

  def base_key_offset
    [r_step_size*r_tuples, s_step_size*@s_tuples].max
  end
end

