=begin
Сумма покупок. Пользователь вводит поочередно название товара, цену за единицу и кол-во купленного товара (может быть нецелым числом).
Пользователь может ввести произвольное кол-во товаров до тех пор, пока не введет "стоп" в качестве названия товара. 
На основе введенных данных требуетеся:
Заполнить и вывести на экран хеш, ключами которого являются названия товаров, а значением - вложенный хеш, содержащий цену за единицу
товара и кол-во купленного товара. Также вывести итоговую сумму за каждый товар.
Вычислить и вывести на экран итоговую сумму всех покупок в "корзине".
=end

basket = {}
total_price = 0

loop do
  puts "enter \'stop\' to exit the program"
  puts "enter the product name:"
  product = gets.chomp
  break if product == "stop"

  puts "enter the price per unit of product:"
  price_per_unit = gets.chomp.to_f

  puts "enter the quantity of the purchased product:"
  quantity = gets.chomp.to_i

  basket[product.to_sym] = {price_per_unit => quantity}
end

separator = "............."
puts
puts "your shopping cart:"
puts "product:          price:          quantity:          total:"
basket.each do |key, value| 
  if key.length > 5
    print "#{key}" + separator[0...(13 - (key.length - 5))]
  else
    print "#{key}" + separator + "." * (5 - key.length) 
  end
  value.each do |k, v|
    print "#{k}.............#{v}.................#{k * v}"
    total_price += k * v
    puts
  end
end

puts "total price: #{total_price}"
