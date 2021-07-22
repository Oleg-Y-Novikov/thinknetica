=begin
Идеальный вес. Программа запрашивает у пользователя имя и рост и выводит идеальный вес по формуле 
(<рост> - 110) * 1.15, после чего выводит результат пользователю на экран с обращением по имени. 
Если идеальный вес получается отрицательным, то выводится строка "Ваш вес уже оптимальный"
=end

class PerfectWeight

  def self.run
    new.run
  end

  def run
    puts "Hello! Please enter your name:"
    user_name = gets.chomp.capitalize
    
    puts "Please enter your height in centimeters:"
    @user_height = gets.chomp
    
    check_height

    puts "enter your gender: man or woman"
    @gender = gets.chomp.downcase

    check_gender

    if @gender == "man"
      result = (@user_height - 100) * 1.15
      if result.negative?
        puts "#{user_name}, your weight is already optimal!"
      else
        puts "#{user_name}, your ideal weight is #{result.round(2)} kg."
      end
    else
      result = (@user_height - 110) * 1.15
      if result.negative?
        puts "#{user_name}, your weight is already optimal!"
      else
        puts "#{user_name}, your ideal weight is #{result.round(2)} kg."
      end
    end
  end

  private

  def check_height
    until @user_height = Integer(@user_height) rescue false
      puts "invalid value, enter only an integer!"
      @user_height = gets.chomp
    end
  end

  def check_gender
    while @gender != "woman" && @gender != "man"
      puts "Please enter \'man\' or \'woman\'"
      @gender = gets.chomp.downcase
    end
  end
end

PerfectWeight.run