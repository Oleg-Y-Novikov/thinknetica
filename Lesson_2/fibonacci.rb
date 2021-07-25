#Заполнить массив числами фибоначчи до 100
#Fn = Fn-1 + Fn-2
array = []

a = 0
b = 1
arr = []
    
while b < 100
	a = b
	b = a+b
	array << a
end

print array