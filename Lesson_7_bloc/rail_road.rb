class RailRoad
  attr_reader :choice

  def info
    return puts "Нет ни одной станции" if Station.all_stations.empty?

    puts "СПИСОК СТАНЦИЙ И ПОЕЗДОВ НА НИХ"
    puts
    Station.all_stations.each do |station| puts station.station_info
      if station.trains_at_station.size != 0
        station.each_trains do |train| 
          puts train.train_info
          train.each_wagons { |wagon| puts wagon.wagon_info }
          puts
        end
      end
      puts
    end
    puts
  end

  def run
    puts "Добро пожаловать в программу управления железной дорогой v.3"
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
          boarding_loading if @choice == 7
          break if @choice == 0
        end
      when 3
        all_created_objects
      when 4
        info
      when "exit"
        exit
      else
        puts "Неизвестная команда!"
        puts
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
    puts "Введите 4, если хотите вывести информацию о всех станциях, поездах на них и о вагонах"
    puts "Введите exit, если хотите закончить программу"
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
    puts "Введите 7, если хотите произвести погрузку груза или посадку пассажиров в вагон"
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
      puts "Список уже существующих станций:"
      puts "#{Station.all_stations.map(&:name)}"
      puts
      begin
        puts "Введите имя станции, для выхода введите \"exit\""
        name = gets.chomp
        break if name == "exit"
        Station.new(name)
        puts "Станция \"#{name}\" успешно создана"
        puts
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
        puts "Список станций:"
        puts "#{Station.all_stations.map(&:name)}"
        puts
        puts "Введите имя станции, для выхода введите \"exit\""
        name = gets.chomp
        break if name == "exit"
        if Station.get_station(name)
          Station.all_stations.delete(Station.get_station(name))
          puts "Станция \"#{name}\" удалена"
        else
          puts "Станции \"#{name}\" не существует, выберите станцию из ранее созданных!"
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
      puts "Список уже существующих поездов:"
      puts "Грузовые: " + (Train.all_trains.select {|t| t.type == "cargo"}).map(&:number).to_s
      puts "Пассажирские: " + (Train.all_trains.select {|t| t.type == "passenger"}).map(&:number).to_s
      puts
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
          puts
        when "cargo"
          CargoTrain.new(number)
          puts "Поезд с номером N #{number} создан. Тип: #{type}"
          puts
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
    return puts "У вас нет ни одного поезда, сначала создайте поезд" if Train.all_trains.empty?
    loop do
      puts "УДАЛЕНИЕ ПОЕЗДОВ!"
      puts "Список поездов:"
      puts "Грузовые: " + (Train.all_trains.select {|t| t.type == "cargo"}).map(&:number).to_s
      puts "Пассажирские: " + (Train.all_trains.select {|t| t.type == "passenger"}).map(&:number).to_s
      puts
      begin
        puts "Введите номер поезда, для выхода введите \"exit\""
        number = gets.chomp
        break if number == "exit"
        if Train.get_train(number)
          Train.all_trains.delete(Train.get_train(number))
          puts "Поезд N #{number} тип: #{type} удален"
          puts
        else
          puts "Такого поезда не существует, выберите поезд из ранее созданных!"
          puts
        end
      rescue => error
        puts error.message
        retry 
      end
    end
    clear
  end

  def create_route
    return puts "У вас нет ни одной станции. Сначала создайте станции!" if Station.all_stations.empty?

    starting_station = nil
    terminal_station = nil
    loop do
      puts "СОЗДАНИЕ МАРШРУТА!"
      puts "Список уже существующих маршрутов:"
      puts "#{Route.all_routes.keys}"
      puts
      puts "Список уже существующих станций:"
      puts "#{Station.all_stations.map(&:name)}"
      puts
      puts "Введите начальную станцию, для выхода введите \"exit\""
      starting_station_name = gets.chomp
      break if starting_station_name == "exit"
      starting_station = Station.get_station(starting_station_name)
      unless starting_station
        puts "Такой станции нет, выберите станцию из ранее созданных!"
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
        puts "Такой станции нет, выберите станцию из ранее созданных!"
      else
        break
      end
    end
    return if starting_station.nil? || terminal_station.nil?

    Route.new(starting_station, terminal_station)
    puts "Маршрут #{starting_station.name}-#{terminal_station.name} успешно создан"
    puts
    rescue RuntimeError => error
      puts error.message
      retry
  end

  def delete_route
    return puts "У вас нет ни одного маршрута, сначала создайте маршрут" if Route.all_routes.empty?

    loop do
      puts "УДАЛЕНИЕ МАРШРУТА!"
      puts "Список маршрутов:"
      puts "#{Route.all_routes.keys}"
      puts
      puts "Введите название маршрута который хотите удалить, для выхода введите \"exit\""
      route_name = gets.chomp
      break if route_name == "exit"
      if Route.all_routes.has_key?(route_name)
        Route.all_routes.delete(route_name)
        puts "Маршрут #{route_name} удален"
        puts
      else
        puts "Нет такого маршрута, выберите из ранее созданных"
        puts
      end
    end
    clear
  end

  def add_station_in_route
    return puts "У вас нет ни одного маршрута, сначала создайте маршрут" if Route.all_routes.empty?

    return puts "У вас нет ни одной станции, сначала создайте станцию" if Station.all_stations.empty?

    loop do
      puts "ДОБАВЛЕНИЕ СТАНЦИЙ В МАРШРУТ!"
      puts "Список маршрутов:"
      puts "#{Route.all_routes.keys}"
      puts
      puts "Введите назнание маршрута, для выхода введите \"exit\""
      route_name = gets.chomp
      break if route_name == "exit"
      puts "Список станций:"
      puts "#{Station.all_stations.map(&:name)}"
      puts
      puts "Введите имя станции которую хотите добавить в маршрут:"
      station_name = gets.chomp
      if Route.all_routes[route_name] && Station.get_station(station_name)
        if Route.all_routes[route_name].add_station(Station.get_station(station_name))
          puts "Станция #{station_name} успешно добавлена в маршрут #{route_name}"
          puts
        else
          puts "Такая станция уже есть в маршруте"
          puts 
        end
      else
        puts "Oшибка, проверьте данные"
        puts
      end
    end
    clear
  end

  def delete_station_in_route
    return puts "У вас нет ни одного маршрута, сначала создайте маршрут" if Route.all_routes.empty?

    return puts "У вас нет ни одной станции, сначала создайте станцию" if Station.all_stations.empty?

    loop do
      puts "УДАЛЕНИЕ СТАНЦИЙ ИЗ МАРШРУТА!"
      puts "Список маршрутов:"
      puts "#{Route.all_routes.keys}"
      puts
      puts "Введите назнание маршрута, для выхода введите \"exit\""
      route_name = gets.chomp
      break if route_name == "exit"
      puts "Список станций:"
      puts "#{Station.all_stations.map(&:name)}"
      puts
      puts "Введите имя станции"
      station_name = gets.chomp
      if Route.all_routes[route_name] && Route.all_routes[route_name].all_station.include?(Station.get_station(station_name))
        if Route.all_routes[route_name].delete_station(Station.get_station(station_name))
          puts "Станция #{station_name} успешно удалена из маршрута #{route_name}"
          puts
        else
          puts "Такой станции нет в маршруте"
          puts
        end
      else
        puts "Oшибка, проверьте данные"
        puts
      end
    end
    clear
  end

  def add_wagon_train
    return puts "Нет вагонов! Сначала создайте вагон." if Wagon.all_wagons.empty?

    return puts "Нет поездов! Создайте их." if Train.all_trains.empty?

    loop do
      puts "ДОБАВЛЕНИЕ ВАГОНОВ К ПОЕЗДАМ!"
      puts "Список поездов:"
      puts "Грузовые: " + (Train.all_trains.select {|t| t.type == "cargo"}).map(&:number).to_s
      puts "Пассажирские: " + (Train.all_trains.select {|t| t.type == "passenger"}).map(&:number).to_s
      puts
      puts "Введите номер поезда, для выхода введите \"exit\""
      number = gets.chomp
      break if number == "exit"
      puts "Список вагонов:"
      puts "#{Wagon.all_wagons.map(&:number)}"
      puts
      puts "Введите номер вагона который хотите добавить:"
      wagon_number = gets.chomp
      return puts "Вагон с номером #{wagon_number} не найден" if Wagon.get_wagon(wagon_number).nil?
      
      if Train.get_train(number)
        if Train.get_train(number).add_wagon(Wagon.get_wagon(wagon_number))
          Wagon.all_wagons.delete(Wagon.get_wagon(wagon_number))
          puts "Вагон успешно добавлен к поезду N #{number}. Кол-во вагонов в составе - #{Train.get_train(number).amount_wagons}"
          puts
        else
          puts "Не удалось выполнить операцию. Остановите поезд: #{Train.get_train(number).speed}км/ч"
          puts "проверьте корректность типа поезда и типа вагона"
          puts
        end
      else
        puts "Такого поезда нет, выберите из ранее созданных!"
        puts
      end
    end
    clear
  end

  def delete_wagon_train
    return puts "Нет поездов! Создайте их." if Train.all_trains.empty?

    loop do
      puts "ОТЦЕПЛЕНИЕ ВАГОНОВ!"
      puts "Список поездов:"
      puts "Грузовые: " + (Train.all_trains.select {|t| t.type == "cargo"}).map(&:number).to_s
      puts "Пассажирские: " + (Train.all_trains.select {|t| t.type == "passenger"}).map(&:number).to_s
      puts
      puts "Введите номер поезда, для выхода введите \"exit\""
      number = gets.chomp
      break if number == "exit"
      if Train.get_train(number)
        if wagon = Train.get_train(number).remove_wagon
          Wagon.all_wagons << wagon
          puts "Вагон успешно отцеплен от поезда N #{number}. Оставшееся кол-во вагонов в составе #{Train.get_train(number).amount_wagons}"
          puts
        else
          puts "Не удалось выполнить операцию. Остановите поезд: #{Train.get_train(number).speed}км/ч"
          puts "Колличество вагонов в составе = #{Train.get_train(number).amount_wagons}"
          puts
        end
      else
        puts "Такого поезда нет, выберите из ранее созданных!"
        puts
      end
    end
    clear
  end

  def set_train_route
    return puts "Сначала создайте поезд!" if Train.all_trains.empty?

    return puts "Создайте маршрут!" if Route.all_routes.empty?

    loop do 
      puts "НАЗНАЧЕНИЕ МАРШРУТА ПОЕЗДАМ!"
      puts "Список поездов:"
      puts "Грузовые: " + (Train.all_trains.select {|t| t.type == "cargo"}).map(&:number).to_s
      puts "Пассажирские: " + (Train.all_trains.select {|t| t.type == "passenger"}).map(&:number).to_s
      puts
      puts "Введите номер поезда, для выхода введите \"exit\""
      number = gets.chomp
      break if number == "exit"
      puts "Список маршрутов:"
      puts "#{Route.all_routes.keys}"
      puts
      puts "Введите имя маршрута на который установить поезд:"
      route_name = gets.chomp
      if Train.get_train(number) && Route.all_routes.has_key?(route_name)
        Train.get_train(number).set_route(Route.all_routes[route_name])
        puts "Поезд № #{number} установлен на маршрут #{route_name}. Текущая станция - #{Train.get_train(number).current_station.name}"
        puts
      else
        puts "Некорректные данные, попробуйте снова!"
        puts
      end
    end
    clear
  end

  def create_wagon
    loop do
      puts "СОЗДАНИЕ ВАГОНОВ!"
      puts "Список уже существующих вагонов:"
      puts "Грузовые: " + (Wagon.all_wagons.select {|w| w.type == "cargo"}).map(&:number).to_s
      puts "Пассажирские: " + (Wagon.all_wagons.select {|w| w.type == "passenger"}).map(&:number).to_s
      puts
      puts "Для создания пассажирского вагона введите - \"passenger\"; грузового - \"cargo\" для выхода введите - \"exit\""
      wagon_type = gets.chomp
      break if wagon_type == "exit"
      case wagon_type
      when "passenger"
        puts "Укажите номер вагона:"
        number = gets.chomp
        puts "Укажите общее количество мест:"
        number_of_seats = gets.chomp.to_i
        PassengerWagon.new(wagon_type, number, number_of_seats)
        puts "Пассажирский вагон № #{number} успешно создан"
        puts
      when "cargo"
        puts "Укажите номер вагона:"
        number = gets.chomp
        puts "Укажите общий объем:"
        total_volume = gets.chomp.to_f
        CargoWagon.new(wagon_type, number, total_volume)
        puts "Грузовой вагон № #{number} успешно создан"
        puts
      else 
        puts "Неверно указан тип вагона, попробуйте снова"
        puts
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
      puts "Список вагонов в депо:"
      puts "Грузовые: " + (Wagon.all_wagons.select {|w| w.type == "cargo"}).map(&:number).to_s
      puts "Пассажирские: " + (Wagon.all_wagons.select {|w| w.type == "passenger"}).map(&:number).to_s
      puts
      puts "Введите номер вагона, для выхода введите - \"exit\""
      wagon_number = gets.chomp
      break if wagon_number == "exit"
      if Wagon.get_wagon(wagon_number)
        Wagon.all_wagons.delete(Wagon.get_wagon(wagon_number))
        puts "Вагон #{wagon_number} успешно удален"
        puts
      else 
        puts "Нет такого вагона в депо, выберите из ранее созданных"
        puts
      end
    end
    clear
  end

  def boarding_loading
    loop do
      begin
        puts "ПОСАДКА/ПОГРУЗКА НА ВАГОНЫ!"
        puts "Список поездов:"
        puts "Грузовые: " + (Train.all_trains.select {|t| t.type == "cargo"}).map(&:number).to_s
        puts "Пассажирские: " + (Train.all_trains.select {|t| t.type == "passenger"}).map(&:number).to_s
        puts
        puts "Введите номер поезда для выхода введите - \"exit\""
        train_number = gets.chomp
        break if train_number == "exit"
        puts "Не добавленные вагоны к поездам: #{Wagon.all_wagons.map(&:number)}" unless Wagon.all_wagons.empty?
        puts "Вагоны в составе поездa #{train_number}:"
        Train.get_train(train_number).wagons.each { |wagon| puts "Вагон № #{wagon.number}" }
      rescue NoMethodError
        puts "Не верно указан номер поезда, повторите попытку"
        retry
      end
      puts "Введите номер вагона:"
      wagon_number = gets.chomp
      if Wagon.get_wagon(wagon_number)
        puts "Сначала прицепите вагон к поезду"
      else
        if Train.get_train(train_number).get_wagon(wagon_number).nil?
          puts "Нет вагона с таким номером"
        elsif Train.get_train(train_number).type == "passenger"
          Train.get_train(train_number).get_wagon(wagon_number).take_a_seat
          puts "Пассажир занял свое место в вагоне"
          puts
        elsif Train.get_train(train_number).type == "cargo"
          puts "Введите объем груза(m3):"
          volume = gets.chomp.to_f
          Train.get_train(train_number).get_wagon(wagon_number).upload(volume)
          puts "Погрузка прошла успешно"
          puts
        end
      end
      rescue RuntimeError => error
        puts error.message
        retry
    end
    clear
  end

  def travel
    return puts "Сначала создайте поезд" if Train.all_trains.empty?

    loop do
      puts "ПЕРЕМЕЩЕНИЕ ПОЕЗДА ПО МАРШРУТУ!"
      puts "Список поездов:"
      puts "Грузовые: " + (Train.all_trains.select {|t| t.type == "cargo"}).map(&:number).to_s
      puts "Пассажирские: " + (Train.all_trains.select {|t| t.type == "passenger"}).map(&:number).to_s
      puts
      puts "Введите номер поезда, для выхода введите - \"exit\""
      number = gets.chomp
      break if number == "exit"
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
    Wagon.all_wagons.each { |wagon| puts "#{wagon.number} #{wagon.type}" }
  end

  def all_created_objects
    list_station
    list_trains
    list_routes
    list_wagons
  end
end
