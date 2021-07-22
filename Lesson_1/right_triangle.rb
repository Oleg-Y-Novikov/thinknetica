=begin
Прямоугольный треугольник. Программа запрашивает у пользователя 3 стороны треугольника и определяет, 
является ли треугольник прямоугольным (используя теорему Пифагора www-formula.ru), равнобедренным 
(т.е. у него равны любые 2 стороны)  или равносторонним (все 3 стороны равны) и выводит результат на экран. 
Подсказка: чтобы воспользоваться теоремой Пифагора, нужно сначала найти самую длинную сторону (гипотенуза) 
и сравнить ее значение в квадрате с суммой квадратов двух остальных сторон. Если все 3 стороны равны, 
то треугольник равнобедренный и равносторонний, но не прямоугольный.
=end
puts "input the first side of the triangle:"
a = gets.chomp.to_i
puts "input the second side of the triangle:"
b = gets.chomp.to_i
puts "input the third side of the triangle:"
c = gets.chomp.to_i

sizes = []
sizes.push(a**2, b**2, c**2)
sizes.sort!
puts sizes

if sizes[0] + sizes[1] == sizes[2]
  puts "the triangle is rectangular" #треугольник прямоугольный
elsif sizes.uniq.length == 1
  puts "the triangle is equilateral" #треугольник равносторонний
elsif sizes.uniq.length == 2
  puts "the triangle is isosceles" #треугольник равнобедренный
else
  puts "the triangle is versatile" #треугольник разносторонний
end
