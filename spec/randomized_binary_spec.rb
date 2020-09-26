# frozen_string_literal: true

scenarios = [
  # same size for relations:
  { r_tuples: 10000, s_tuples: 10000, join_tuples: 10 },
  { r_tuples: 10000, s_tuples: 10000, join_tuples: 100 },
  { r_tuples: 10000, s_tuples: 10000, join_tuples: 1000 },
  { r_tuples: 10000, s_tuples: 10000, join_tuples: 10000 },
  # { r_tuples: 10000, s_tuples: 10000, join_tuples: 100000 },
  # { r_tuples: 10000, s_tuples: 10000, join_tuples: 1000000 },

  # # r a little bigger
  { r_tuples: 10000, s_tuples: 9000, join_tuples: 10 },
  { r_tuples: 10000, s_tuples: 9000, join_tuples: 100 },
  { r_tuples: 10000, s_tuples: 9000, join_tuples: 1000 },
  { r_tuples: 10000, s_tuples: 9000, join_tuples: 10000 },
  # { r_tuples: 10000, s_tuples: 9000, join_tuples: 100000 },
  # { r_tuples: 10000, s_tuples: 9000, join_tuples: 1000000 },

  # # r much bigger
  { r_tuples: 10000, s_tuples: 50, join_tuples: 10 },
  { r_tuples: 10000, s_tuples: 50, join_tuples: 100 },
  { r_tuples: 10000, s_tuples: 50, join_tuples: 1000 },
  { r_tuples: 10000, s_tuples: 50, join_tuples: 10000 },
  # { r_tuples: 10000, s_tuples: 50, join_tuples: 100000 },
  # { r_tuples: 10000, s_tuples: 50, join_tuples: 1000000 }
]

RSpec.describe RandomizedBinary do
  it 'produces at least the correct amount of tuples' do
    scenarios.each do |scenario|
      rb = RandomizedBinary.new scenario[:r_tuples], scenario[:s_tuples], scenario[:join_tuples]
      rb.generate
      size = rb.current_join_size
      expect(size).to be_within(1).percent_of(scenario[:join_tuples])
    end
  end
end