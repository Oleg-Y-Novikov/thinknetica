class RailRoad
  attr_reader :choice

  def run
    puts "Добро пожаловать в программу управления железной дорогой v.2"
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
        all_created_objects
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

  def create_station
    loop do
      puts "СОЗДАНИЕ СТАНЦИЙ!"
      begin
        puts "Введите имя станции, для выхода введите \"exit\""
        name = gets.chomp
        break if name == "exit"
        Station.new(name)
        puts "Станция \"#{name}\" успешно создана"
      rescue RuntimeError => error
        puts error.message
        retry
      end
    end
    clear
  end

  def delete_station
    loop do
      puts "УДАЛЕНИЕ СТАНЦИЙ!"
      return puts "У вас нет ни одной станции. Создайте станцию!" if Station.all_stations.empty?

      begin
        puts "Введите имя станции, для выхода введите \"exit\""
        name = gets.chomp
        break if name == "exit"
        if Station.get_station(name)
          Station.all_stations.delete(Station.get_station(name))
          puts "Станция \"#{name}\" удалена"
        else
          puts "Станции \"#{name}\" не существует, выберите станцию из ранее созданных #{Station.all_stations.map(&:name)}"
        end
      rescue => error
        puts "Произошла ошибка #{error.message}. Повторите попытку"
        retry
      end
    end
    clear
  end

  def create_train
    loop do
      puts "СОЗДАНИЕ ПОЕЗДОВ!"
      begin
        puts "Введите номер поезда, для выхода введите \"exit\""
        number = gets.chomp
        break if number == "exit"
        puts "Введите тип поезда: \"passenger\" - пассажирский; \"cargo\" - грузовой"
        type = gets.chomp
        case type
        when "passenger"
          PassengerTrain.new(number)
          puts "Поезд с номером N #{number} создан. Тип: #{type}"
        when "cargo"
          CargoTrain.new(number)
          puts "Поезд с номером N #{number} создан. Тип: #{type}"
        else 
          puts "Неверно указан тип поезда, попробуйте снова"
        end
      rescue RuntimeError => error
        puts error.message
        retry
      end
    end
    clear
  end

  def delete_train
    loop do
      puts "УДАЛЕНИЕ ПОЕЗДОВ!"
      return puts "У вас нет ни одного поезда, сначала создайте поезд" if Train.all_trains.empty?

      begin
        puts "Введите номер поезда, для выхода введите \"exit\""
        number = gets.chomp
        break if number == "exit"
        if Train.get_train(number)
          Train.all_trains.delete(Train.get_train(number))
          puts "Поезд N #{number} тип: #{type} удален"
        else
          puts "Такого поезда не существует, выберите поезд из ранее созданных"
          Train.all_trains.each { |train| puts "N #{train.number}, тип #{train.type}" }
        end
      rescue => error
        puts error.message
        retry 
      end
    end
    clear
  end

  def create_route
    starting_station = nil
    terminal_station = nil
    loop do
      puts "СОЗДАНИЕ МАРШРУТА!"
      return puts "У вас нет ни одной станции. Сначала создайте станции!" if Station.all_stations.empty?

      puts "Введите начальную станцию, для выхода введите \"exit\""
      starting_station_name = gets.chomp
      break if starting_station_name == "exit"
      starting_station = Station.get_station(starting_station_name)
      unless starting_station
        puts "Такой станции нет, выберите станцию из ранее созданных #{Station.all_stations.map(&:name)}"
      else
        break
      end
    end
    loop do
      puts "Введите конечную станцию, для выхода введите \"exit\""
      terminal_station_name = gets.chomp
      break if terminal_station_name == "exit"
      terminal_station = Station.get_station(terminal_station_name)
      unless terminal_station
        puts "Такой станции нет, выберите станцию из ранее созданных #{Station.all_stations.map(&:name)}"
      else
        break
      end
    end
    return if starting_station.nil? || terminal_station.nil?

    Route.new(starting_station, terminal_station)
    puts "Маршрут #{starting_station.name}-#{terminal_station.name} успешно создан"
    rescue RuntimeError => error
      puts error.message
      retry
  end

  def delete_route
    return puts "У вас нет ни одного маршрута, сначала создайте маршрут" if Route.all_routes.empty?

    loop do
      puts "УДАЛЕНИЕ МАРШРУТА!"
      puts "Введите название маршрута который хотите удалить, для выхода введите \"exit\""
      route_name = gets.chomp
      break if route_name == "exit"
      if Route.all_routes.has_key?(route_name)
        Route.all_routes.delete(route_name)
        puts "Маршрут #{route_name} удален"
      else
        puts "Нет такого маршрута, выберите из ранее созданных"
        Route.all_routes.each_key { |name| puts name }
      end
    end
    rescue => error
      puts error.message
      retry 
    clear
  end

  def add_station_in_route
    return puts "У вас нет ни одного маршрута, сначала создайте маршрут" if Route.all_routes.empty?

    return puts "У вас нет ни одной станции, сначала создайте станцию" if Station.all_stations.empty?

    loop do
      puts "ДОБАВЛЕНИЕ СТАНЦИЙ В МАРШРУТ!"
      puts "Введите назнание маршрута, для выхода введите \"exit\""
      route_name = gets.chomp
      break if route_name == "exit"
      puts "Введите имя станции которую хотите добавить в маршрут:"
      station_name = gets.chomp
      if Route.all_routes[route_name] && Station.get_station(station_name)
        if Route.all_routes[route_name].add_station(Station.get_station(station_name))
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
    return puts "У вас нет ни одного маршрута, сначала создайте маршрут" if Route.all_routes.empty?

    return puts "У вас нет ни одной станции, сначала создайте станцию" if Station.all_stations.empty?

    loop do
      puts "УДАЛЕНИЕ СТАНЦИЙ ИЗ МАРШРУТА!"
      puts "Введите назнание маршрута, для выхода введите \"exit\""
      route_name = gets.chomp
      break if route_name == "exit"
      puts "Введите имя станции"
      station_name = gets.chomp
      if Route.all_routes[route_name] && Route.all_routes[route_name].all_station.include?(Station.get_station(station_name))
        if Route.all_routes[route_name].delete_station(Station.get_station(station_name))
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
    return puts "Нет вагонов! Сначала создайте вагон." if Wagon.all_wagons.empty?

    return puts "Нет поездов! Создайте их." if Train.all_trains.empty?

    loop do
      puts "ДОБАВЛЕНИЕ ВАГОНОВ К ПОЕЗДАМ!"
      puts "Введите номер поезда, для выхода введите \"exit\""
      number = gets.chomp
      break if number == "exit"
      begin
        puts "Введите тип вагона который хотите добавить: \"passenger\" - пассажирский; \"cargo\" - грузовой"
        wagon_type = gets.chomp
        Wagon.valid?(wagon_type)
      rescue RuntimeError => error
        puts error.message
        retry
      end 
      break puts "Нет свободных вагонов данного типа, создайте их" if Wagon.get_wagon(wagon_type).nil?
      if Train.get_train(number)
        if Train.get_train(number).add_wagon(Wagon.get_wagon(wagon_type))
          Wagon.all_wagons.delete(Wagon.get_wagon(wagon_type))
          puts "Вагон успешно добавлен к поезду N #{number}. Кол-во вагонов в составе - #{Train.get_train(number).amount_wagons}"
        else
          puts "Не удалось выполнить операцию. Остановите поезд: #{Train.get_train(number).speed}км/ч"
          puts "проверьте корректность типа поезда \"#{type}\" и типа вагона \"#{wagon_type}\""
        end
      else
        puts "Такого поезда нет, выберите из ранее созданных #{Train.all_trains.map(&:number)}"
      end
    end
    clear
  end

  def delete_wagon_train
    return puts "Нет поездов! Создайте их." if Train.all_trains.empty?

    loop do
      puts "ОТЦЕПЛЕНИЕ ВАГОНОВ!"
      puts "Введите номер поезда, для выхода введите \"exit\""
      number = gets.chomp
      break if number == "exit"
      if Train.get_train(number)
        if wagon = Train.get_train(number).remove_wagon
          Wagon.all_wagons << wagon
          puts "Вагон успешно отцеплен от поезда N #{number}. Оставшееся кол-во вагонов в составе #{Train.get_train(number).amount_wagons}"
        else
          puts "Не удалось выполнить операцию. Остановите поезд: #{Train.get_train(number).speed}км/ч"
          puts "Колличество вагонов в составе = #{Train.get_train(number).amount_wagons}"
        end
      else
        puts "Такого поезда нет, выберите из ранее созданных #{Train.all_trains.map(&:number)}"
      end
    end
    clear
  end

  def set_train_route
    return puts "Сначала создайте поезд!" if Train.all_trains.empty?

    return puts "Создайте маршрут!" if Route.all_routes.empty?

    loop do 
      puts "НАЗНАЧЕНИЕ МАРШРУТА ПОЕЗДАМ!"
      puts "Введите номер поезда, для выхода введите \"exit\""
      number = gets.chomp
      break if number == "exit"
      puts "Введите имя маршрута на который установить поезд:"
      route_name = gets.chomp
      if Train.get_train(number) && Route.all_routes.has_key?(route_name)
        Train.get_train(number).set_route(Route.all_routes[route_name])
        puts "Поезд № #{number} установлен на маршрут #{route_name}. Текущая станция - #{Train.get_train(number).current_station.name}"
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
        PassengerWagon.new(wagon_type)
        puts "Пассажирский вагон успешно создан"
      when "cargo" 
        CargoWagon.new(wagon_type)
        puts "Грузовой вагон успешно создан"
      else 
        Wagon.send :validate!, wagon_type
      end
      rescue RuntimeError => error
        puts error.message
        retry
    end
    clear
  end

  def delete_wagon
    return puts "У вас нет ни одного вагона" if Wagon.all_wagons.empty?

    loop do
      puts "УДАЛЕНИЕ ВАГОНОВ!"
      puts "Для удаления пассажирского вагона введите - \"passenger\"; грузового - \"cargo\" для выхода введите - \"exit\""
      wagon_type = gets.chomp
      break if wagon_type == "exit"
      case wagon_type
      when "passenger"
        Wagon.all_wagons.delete(Wagon.get_wagon(wagon_type))
        puts "Пассажирский вагон успешно удален"
      when "cargo" 
        Wagon.all_wagons.delete(Wagon.get_wagon(wagon_type))
        puts "Грузовой вагон успешно удален"
      else 
        puts "Неверно указан тип вагона, попробуйте снова"
      end
    end
    clear
  end

  def travel
    return puts "Сначала создайте поезд" if Train.all_trains.empty?

    loop do
      puts "ПЕРЕМЕЩЕНИЕ ПОЕЗДА ПО МАРШРУТУ!"
      puts "Введите номер поезда, для выхода введите - \"exit\""
      number = gets.chomp
      break if number == "exit"
      #puts "Введите тип поезда: \"passenger\" - пассажирский; \"cargo\" - грузовой"
      #type = gets.chomp
      if Train.get_train(number)
        return puts "Сначала установите маршрут для данного поезда" if Train.get_train(number).route.nil?

        loop do
          puts "Двигаться на следующую станцию введите - \"next\", на предыдущую - \"back\", сменить поезд введите \"exit\""
          choice = gets.chomp
          break if choice == "exit"
          case choice
          when "next"
            if Train.get_train(number).go_ahead
              puts "Поезд № #{number} прибыл на станцию - #{Train.get_train(number).current_station.name}"
            else
              puts "Поезд № #{number} на конечной станции - #{Train.get_train(number).current_station.name}. Покиньте вагон."
            end
          when "back"
            if Train.get_train(number).go_back
              puts "Поезд № #{number} прибыл на станцию - #{Train.get_train(number).current_station.name}"
            else
              puts "Поезд № #{number} на начальной станции - #{Train.get_train(number).current_station.name}."
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
    return puts "Нет ни одной станции" if Station.all_stations.empty? 

    puts "СПИСОК СТАНЦИЙ И ПОЕЗДОВ НА НИХ"
    Station.all_stations.each do |station|
      puts "Станция - #{station.name}; поездов на станции - #{station.trains_at_station.size}"
      if station.trains_at_station.size != 0
        station.trains_at_station.each { |train| puts "Поезд № #{train.number}; тип - #{train.type}" }
      end
    end
  end

  def list_trains
    return puts "Нет ни одного поезда" if Train.all_trains.empty? 

    puts "СПИСОК СОЗДАННЫХ ПОЕЗДОВ"
    Train.all_trains.each { |train| puts "Поезд № #{train.number}, тип: #{train.type}" }
  end

  def list_routes
    return puts "Нет ни одного маршрута" if Route.all_routes.empty? 

    puts "СПИСОК СОЗДАННЫХ МАРШРУТОВ"
    Route.all_routes.each_key { |route| puts "Маршрут: #{route}" }
  end

  def list_wagons
    return puts "Нет ни одного вагона" if Wagon.all_wagons.empty? 

    puts "СПИСОК СОЗДАННЫХ ВАГОНОВ"
    Wagon.all_wagons.each { |wagon| puts wagon.type }
  end

  def all_created_objects
    list_station
    list_trains
    list_routes
    list_wagons
  end
end




