def select(array)
  index = 0
  new_array = []
  while index < array.length
    if yield(array[index])
      new_array << array[index]
    end
    index += 1
  end
  new_array
end

p select([1, 2, 3, 4, 5]) { |num| num.odd? }