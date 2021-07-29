#Заполнить массив числами от 10 до 100 с шагом 5

array = []
num = 10
while num <= 100
  array << num
  num += 5
end

print array

#способ 2
array = (10..100).step(5).to_a
print array
