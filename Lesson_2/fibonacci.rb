#Заполнить массив числами фибоначчи до 100
#Fn = Fn-1 + Fn-2

array = []

if array.empty?
  array.push(0, 1)
else
  array.clear
  array.push(0, 1)
end

while array[-1] + array[-2] < 100
  array << array[-1] + array[-2]
end

print array
