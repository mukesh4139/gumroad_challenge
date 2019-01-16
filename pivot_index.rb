class PivotIndex
  attr_reader :nums
  
  def initialize(arr = [])
    @nums = arr
  end

  def call
    right_sum = 0
    left_sum = 0 
    sum = nums.reduce(&:+)
    
    nums.each_with_index do |num, i|
      right_sum = sum - left_sum - num
      return i if left_sum == right_sum
      left_sum += num
    end
    
    return -1
  end
end

nums = [1, 7, 3, 6, 5, 6]
pivot_index = PivotIndex.new(nums)
puts pivot_index.call

