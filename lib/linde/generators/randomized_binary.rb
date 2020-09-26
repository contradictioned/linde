# This constructs a single binary join between relations R and S.
# It can be customized in the following dimensions:
#
#   r_tuples:     number of tuples of relation R to be generated
#   s_tuples:     number of tuples of relation S to be generated
#   join_tuples:  number of tuples in the join result
class RandomizedBinary
  attr_accessor :r_tuples, :s_tuples, :join_tuples
  attr_reader :current_join_size

  def initialize r_tuples, s_tuples, join_tuples
    @r_tuples = r_tuples
    @s_tuples = s_tuples
    @join_tuples = join_tuples

    # internal state
    @key_counter = 0
    @r_frequencies = {}
    @s_frequencies = {}
    @current_join_size = 0
  end

  def generate
    @r = Array.new(@r_tuples)
    @s = Array.new(@s_tuples)

    @join_tuples.times do
      insert_new_random_edge
      break if current_join_size > @join_tuples
    end

    [@r, @s]
  end

  private

  def insert_new_random_edge
    r_index, s_index = find_random_pair
    # at least one of @r[r_index] and @s[s_index] is nil
    join_key = join_key_for r_index, s_index

    # update frequencies and size
    if @r[r_index].nil? && !@s[s_index].nil?
      @r_frequencies[join_key] += 1
      @current_join_size += @s_frequencies[join_key]
    elsif !@r[r_index].nil? && @s[s_index].nil?
      @s_frequencies[join_key] += 1
      @current_join_size += @r_frequencies[join_key]
    elsif @r[r_index].nil? && @s[s_index].nil?
      @r_frequencies[join_key] = 1
      @s_frequencies[join_key] = 1
      @current_join_size += 1
    end

    @r[r_index] = join_key
    @s[s_index] = join_key    
  end

  def find_random_pair
    r_index = -1
    s_index = -1
    while true
      r_candidate = rand(@r_tuples)
      s_candidate = rand(@s_tuples)
      next if @r[r_candidate] != nil && @s[s_candidate] != nil
      r_index = r_candidate
      s_index = s_candidate
      break
    end
    [r_index, s_index]
  end

  def join_key_for r_index, s_index
    if @r[r_index] == nil && @s[s_index] == nil
      @key_counter += 1
      return @key_counter
    else
      if @r[r_index] == nil
        return @s[s_index]
      end
      if @s[s_index] == nil
        return @r[r_index]
      end
    end
  end
end

