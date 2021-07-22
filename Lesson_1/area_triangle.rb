=begin
Площадь треугольника. Площадь треугольника можно вычислить, зная его основание (a) и высоту (h) 
по формуле: 1/2*a*h. Программа должна запрашивать основание и высоту треугольника и возвращать его площадь.
=end

puts "enter the base of the triangle:"
base = gets.chomp.to_f

puts "enter the height of the triangle:"
height = gets.chomp.to_f

result = 0.5 * base * height
puts "the area of the triangle is equal to #{result}"