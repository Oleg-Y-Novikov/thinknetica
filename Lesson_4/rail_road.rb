require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'wagon'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'

class RailRoad
  attr_reader :choice

  def initialize
    @trains = []
    @stations = []
    @routes = {}
    @wagons = []
  end

  def run
    puts "Добро пожаловать в программу управления железной дорогой v.1"
    loop do
      main_menu
      user_choice
      clear
      case @choice
      when 1
        loop do
          menu_1
          user_choice
          clear
          create_station if @choice == 1
          create_train if @choice == 2
          create_route if @choice == 3
          create_wagon if @choice == 4
          delete_station if @choice == 5
          delete_train if @choice == 6
          delete_route if @choice == 7
          delete_wagon if @choice == 8
          break if @choice == 0
        end
      when 2
        loop do
          menu_2
          user_choice
          clear
          delete_station_in_route if @choice == 1
          add_station_in_route if @choice == 2
          set_train_route if @choice == 3
          add_wagon_train if @choice == 4
          delete_wagon_train if @choice == 5
          travel if @choice == 6
          break if @choice == 0
        end
      when 3
        list_station
      when 0
        exit
      else
        puts "Введены не корректрые данные!"
      end
    end
  end

  private

  def self.run
    new.run
  end

  def main_menu
    puts "Введите 1, если хотите создать или удалить станцию, поезд, вагон или маршрут"
    puts "Введите 2, если хотите произвести операции с созданными объектами"
    puts "Введите 3, если хотите вывести текущие данные о объектах"
    puts "Введите 0, если хотите закончить программу"
  end
  
  def menu_1
    puts "Введите 1, если хотите создать станцию"
    puts "Введите 2, если хотите создать поезд"
    puts "Введите 3, если хотите создать маршрут"
    puts "Введите 4, если хотите создать вагон"
    puts 
    puts "Введите 5, если хотите удалить станцию"
    puts "Введите 6, если хотите удалить поезд"
    puts "Введите 7, если хотите удалить маршрут"
    puts "Введите 8, если хотите удалить вагон"
    puts "Введите 0, чтобы вернуться в главное меню"
  end

  def menu_2
    puts "Введите 1, если хотите удалить промежуточную станцию из маршрута"
    puts "Введите 2, если хотите добавить промежуточную станцию в маршрут"
    puts "Введите 3, если хотите задать маршрут для поезда"
    puts "Введите 4, если хотите прицепить вагон к поезду"
    puts "Введите 5, если хотите отцепить вагон от поезда"
    puts "Введите 6, если хотите перемещать поезд по маршруту"
    puts "Введите 0, чтобы вернуться в главное меню"
  end

  def clear
    system "clear" or system "cls"
  end

  def user_choice
    @choice = gets.chomp.to_i
  end

  def get_station(name)
    @stations.find { |station| station.name == name }
  end

  def get_train(number, type)
    @trains.find { |train| train.number == number && train.type == type }
  end

  def get_wagon(type)
    @wagons.find { |wagon| wagon.type == type }
  end  

  def create_station
    loop do
      puts "СОЗДАНИЕ СТАНЦИЙ!"
      puts "Введите имя станции, для выхода введите \"exit\""
      name = gets.chomp
      break if name == "exit"
      if get_station(name)
        puts "Станция с таким именем уже существует"
      elsif name.empty?
        puts "Имя станции не может быть пустым"
      else
        @stations << Station.new(name)
        puts "Станция \"#{name}\" создана"
      end
    end
    clear
  end

  def delete_station
    loop do
      puts "УДАЛЕНИЕ СТАНЦИЙ!"
      puts "Введите имя станции, для выхода введите \"exit\""
      name = gets.chomp
      break if name == "exit"
      if get_station(name)
        @stations.delete(get_station(name))
        puts "Станция \"#{name}\" удалена"
      else
        puts "Станции \"#{name}\" не существует, выберите станцию из ранее созданных #{@stations.map(&:name)}"
      end
    end
    clear
  end

  def create_train
    loop do
      puts "СОЗДАНИЕ ПОЕЗДОВ!"
      puts "Введите номер поезда, для выхода введите \"exit\""
      number = gets.chomp
      break if number == "exit"
      puts "Введите тип поезда: \"passenger\" - пассажирский; \"cargo\" - грузовой"
      type = gets.chomp
      if get_train(number, type)
        puts "Поезд с таким номером и тем же типом уже существует"
      else
        case type
        when "passenger"
          @trains << PassengerTrain.new(number)
          puts "Поезд с номером N #{number} создан. Тип: #{get_train(number, type).type}"
        when "cargo"
          @trains << CargoTrain.new(number)
          puts "Поезд с номером N #{number} создан. Тип: #{get_train(number, type).type}"
        else 
          puts "Неверно указан тип поезда, попробуйте снова"
        end
      end
    end
    clear
  end

  def delete_train
    return puts "У вас нет ни одного поезда, сначала создайте поезд" if @trains.empty?

    loop do
      puts "УДАЛЕНИЕ ПОЕЗДОВ!"
      puts "Введите номер поезда, для выхода введите \"exit\""
      number = gets.chomp
      break if number == "exit"
      puts "Введите тип поезда: \"passenger\" - пассажирский; \"cargo\" - грузовой"
      type = gets.chomp
      if get_train(number, type)
        puts "Поезд N #{get_train(number, type).number} тип: #{get_train(number, type).type} удален"
        @trains.delete(get_train(number, type))
      else
        puts "Такого поезда не существует, выберите поезд из ранее созданных"
        @trains.each { |train| puts "N #{train.number}, тип #{train.type}" }
      end
    end
    clear
  end

  def create_route
    starting_station = nil
    terminal_station = nil
    loop do
      puts "СОЗДАНИЕ МАРШРУТА!"
      puts "Введите начальную станцию, для выхода введите \"exit\""
      starting_station_name = gets.chomp
      break if starting_station_name == "exit"
      starting_station = get_station(starting_station_name)
      unless starting_station
        puts "Такой станции нет, выберите станцию из ранее созданных #{@stations.map(&:name)}"
      else
        break
      end
    end
    loop do
      puts "Введите конечную станцию, для выхода введите \"exit\""
      terminal_station_name = gets.chomp
      break if terminal_station_name == "exit"
      terminal_station = get_station(terminal_station_name)
      if terminal_station
        break if terminal_station != starting_station
        puts "Начальная и конечная станция не должны совпадать"
      else
        puts "Такой станции нет, выберите станцию из ранее созданных #{@stations.map(&:name)}"
      end
    end
    return if terminal_station.nil? || starting_station.nil?

    @routes["#{starting_station.name}-#{terminal_station.name}"] = Route.new(starting_station, terminal_station)
    puts "Маршрут #{starting_station.name}-#{terminal_station.name} создан"
  end

  def delete_route
    return puts "У вас нет ни одного маршрута, сначала создайте маршрут" if @routes.empty?

    loop do
      puts "УДАЛЕНИЕ МАРШРУТА!"
      return puts "У вас нет ни одного маршрута, сначала создайте маршрут" if @routes.empty?
      puts "Введите название маршрута который хотите удалить, для выхода введите \"exit\""
      route_name = gets.chomp
      break if route_name == "exit"
      if @routes.has_key?(route_name)
        @routes.delete(route_name)
        puts "Маршрут #{route_name} удален"
      else
        puts "Нет такого маршрута, выберите из ранее созданных"
        @routes.each_key { |name| puts name }
      end
    end
    clear
  end

  def add_station_in_route
    return puts "У вас нет ни одного маршрута, сначала создайте маршрут" if @routes.empty?

    return puts "У вас нет ни одной станции, сначала создайте станцию" if @stations.empty?

    loop do
      puts "ДОБАВЛЕНИЕ СТАНЦИЙ В МАРШРУТ!"
      puts "Введите назнание маршрута, для выхода введите \"exit\""
      route_name = gets.chomp
      break if route_name == "exit"
      puts "Введите имя станции которую хотите добавить в маршрут:"
      station_name = gets.chomp
      if @routes[route_name] && get_station(station_name)
        if @routes[route_name].add_station(get_station(station_name))
          puts "Станция #{station_name} успешно добавлена в маршрут #{route_name}"
        else
          puts "Такая станция уже есть в маршруте" 
        end
      else
        puts "Oшибка, проверьте данные"
      end
    end
    clear
  end

  def delete_station_in_route
    return puts "У вас нет ни одного маршрута, сначала создайте маршрут" if @routes.empty?

    return puts "У вас нет ни одной станции, сначала создайте станцию" if @stations.empty?

    loop do
      puts "УДАЛЕНИЕ СТАНЦИЙ ИЗ МАРШРУТА!"
      puts "Введите назнание маршрута, для выхода введите \"exit\""
      route_name = gets.chomp
      break if route_name == "exit"
      puts "Введите имя станции"
      station_name = gets.chomp
      if @routes[route_name] && @routes[route_name].all_station.include?(get_station(station_name))
        if @routes[route_name].delete_station(get_station(station_name))
          puts "Станция #{station_name} успешно удалена из маршрута #{route_name}"
        else
          puts "Такой станции нет в маршруте" 
        end
      else
        puts "Oшибка, проверьте данные"
      end
    end
    clear
  end

  def add_wagon_train
    return puts "Сначала создайте вагон" if @wagons.empty?

    return puts "Нет поездов! Создайте их." if @trains.empty?

    loop do
      puts "ДОБАВЛЕНИЕ ВАГОНОВ К ПОЕЗДАМ!"
      puts "Введите номер поезда, для выхода введите \"exit\""
      number = gets.chomp
      break if number == "exit"
      puts "Введите тип поезда: \"passenger\" - пассажирский; \"cargo\" - грузовой"
      type = gets.chomp
      puts "Введите тип вагона который хотите добавить: \"passenger\" - пассажирский; \"cargo\" - грузовой"
      wagon_type = gets.chomp
      break puts "Нет свободных вагонов данного типа, создайте их" if get_wagon(wagon_type).nil?
      if get_train(number, type)
        if get_train(number, type).add_wagon(get_wagon(wagon_type))
          @wagons.delete(get_wagon(wagon_type))
          puts "Вагон успешно добавлен к поезду N #{number}. Кол-во вагонов в составе - #{get_train(number, type).amount_wagons}"
        else
          puts "Не удалось выполнить операцию. Остановите поезд: #{get_train(number, type).speed}км/ч"
          puts "проверьте корректность типа поезда \"#{type}\" и типа вагона \"#{wagon_type}\""
        end
      else
        puts "Такого поезда нет"
      end
    end
    clear
  end

  def delete_wagon_train
    return puts "Нет поездов! Создайте их." if @trains.empty?

    loop do
      puts "ОТЦЕПЛЕНИЕ ВАГОНОВ!"
      puts "Введите номер поезда, для выхода введите \"exit\""
      number = gets.chomp
      break if number == "exit"
      puts "Введите тип поезда: \"passenger\" - пассажирский; \"cargo\" - грузовой"
      type = gets.chomp
      if get_train(number, type)
        if wagon = get_train(number, type).remove_wagon
          @wagons << wagon
          puts "Вагон успешно отцеплен от поезда N #{number}. Оставшееся кол-во вагонов в составе #{get_train(number, type).amount_wagons}"
        else
          puts "Не удалось выполнить операцию. Остановите поезд: #{get_train(number, type).speed}км/ч"
          puts "Колличество вагонов в составе = #{get_train(number, type).amount_wagons}"
        end
      else
        puts "Такого поезда нет"
      end
    end
    clear
  end

  def set_train_route
    return puts "Сначала создайте поезд!" if @trains.empty?

    return puts "Создайте маршрут!" if @routes.empty?

    loop do 
      puts "НАЗНАЧЕНИЕ МАРШРУТА ПОЕЗДАМ!"
      puts "Введите номер поезда, для выхода введите \"exit\""
      number = gets.chomp
      break if number == "exit"
      puts "Введите тип поезда: \"passenger\" - пассажирский; \"cargo\" - грузовой"
      type = gets.chomp
      puts "Введите имя маршрута на который установить поезд:"
      route_name = gets.chomp
      if get_train(number, type) && @routes.has_key?(route_name)
        get_train(number, type).set_route(@routes[route_name])
        puts "Поезд № #{number} тип - #{type} установлен на маршрут #{route_name}. Текущая станция - #{get_train(number, type).current_station.name}"
      else
        puts "Некорректные данные, попробуйте снова!"
      end
    end
    clear
  end

  def create_wagon
    loop do
      puts "СОЗДАНИЕ ВАГОНОВ!"
      puts "Для создания пассажирского вагона введите - \"passenger\"; грузового - \"cargo\" для выхода введите - \"exit\""
      wagon_type = gets.chomp
      break if wagon_type == "exit"
      case wagon_type
      when "passenger"
        @wagons << PassengerWagon.new(wagon_type)
        puts "Пассажирский вагон успешно создан"
      when "cargo" 
        @wagons << CargoWagon.new(wagon_type)
        puts "Грузовой вагон успешно создан"
      else 
        puts "Неверно введенные данные, попробуйте снова"
      end
    end
    clear
  end

  def delete_wagon
    return puts "У вас нет ни одного вагона" if @wagons.empty?

    loop do
      puts "УДАЛЕНИЕ ВАГОНОВ!"
      puts "Для удаления пассажирского вагона введите - \"passenger\"; грузового - \"cargo\" для выхода введите - \"exit\""
      wagon_type = gets.chomp
      break if wagon_type == "exit"
      case wagon_type
      when "passenger"
        @wagons.delete(get_wagon(wagon_type))
        puts "Пассажирский вагон успешно удален"
      when "cargo" 
        @wagons.delete(get_wagon(wagon_type))
        puts "Грузовой вагон успешно удален"
      else 
        puts "Неверно введенные данные, попробуйте снова"
      end
    end
    clear
  end

  def travel
    return puts "Сначала создайте поезд" if @trains.empty?

    loop do
      puts "ПЕРЕМЕЩЕНИЕ ПОЕЗДА ПО МАРШРУТУ!"
      puts "Введите номер поезда, для выхода введите - \"exit\""
      number = gets.chomp
      break if number == "exit"
      puts "Введите тип поезда: \"passenger\" - пассажирский; \"cargo\" - грузовой"
      type = gets.chomp
      if get_train(number, type)
        return puts "Сначала установите маршрут для данного поезда" if get_train(number, type).route.nil?

        loop do
          puts "Двигаться на следующую станцию введите - \"next\", на предыдущую - \"back\", сменить поезд введите \"exit\""
          choice = gets.chomp
          break if choice == "exit"
          case choice
          when "next"
            if get_train(number, type).go_ahead
              puts "Поезд № #{number} прибыл на станцию - #{get_train(number, type).current_station.name}"
            else
              puts "Поезд № #{number} на конечной станции - #{get_train(number, type).current_station.name}. Покиньте вагон."
            end
          when "back"
            if get_train(number, type).go_back
              puts "Поезд № #{number} прибыл на станцию - #{get_train(number, type).current_station.name}"
            else
              puts "Поезд № #{number} на начальной станции - #{get_train(number, type).current_station.name}."
            end
          else
            puts "Неверно введенные данные, попробуйте снова"
          end
        end
      else
        puts "Нет такого поезда, проверьте данные"
      end
    end
    clear
  end

  def list_station
    return puts "Нет ни одной станции" if @stations.empty? 

    puts "СПИСОК СТАНЦИЙ И ПОЕЗДОВ НА НИХ"
    @stations.each do |station|
      puts "Станция - #{station.name}; поездов на станции - #{station.trains_at_station.size}"
      if station.trains_at_station.size != 0
        station.trains_at_station.each { |train| puts "Поезд № #{train.number}; тип - #{train.type}" }
      end
    end
  end
end

RailRoad.run
