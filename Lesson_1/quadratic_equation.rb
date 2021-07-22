=begin
Квадратное уравнение. Пользователь вводит 3 коэффициента a, b и с. Программа вычисляет дискриминант (D) 
и корни уравнения (x1 и x2, если они есть) и выводит значения дискриминанта и корней на экран. 
При этом возможны следующие варианты:
  Если D > 0, то выводим дискриминант и 2 корня
  Если D = 0, то выводим дискриминант и 1 корень (т.к. корни в этом случае равны)
  Если D < 0, то выводим дискриминант и сообщение "Корней нет"
Подсказка: Алгоритм решения с блок-схемой (www.bolshoyvopros.ru). Для вычисления квадратного корня, нужно использовать  
 
Math.sqrt
 
 Например,  
 
Math.sqrt(16)
 
  вернет 4, т.е. квадратный корень из 16.
=end
puts "enter the coefficient \'a\':"
a = gets.chomp.to_i
puts "enter the coefficient \'b\':"
b = gets.chomp.to_i
puts "enter the coefficient \'c\':"
c = gets.chomp.to_i

d = b**2 - 4 * a * c

if d < 0
  puts "discriminant = #{d}, there are no roots"
elsif d == 0
  x = -b/(2 * a)
  puts "discriminant = #{d}, one root x = #{x}"
elsif d > 0
  x1 = -b + Math.sqrt(d)/(2 * a)
  x2 = -b - Math.sqrt(d)/(2 * a)
  puts "discriminant = #{d}, two root: x1 = #{x1}, x2 = #{x2}"
end