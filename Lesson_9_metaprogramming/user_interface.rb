# frozen_string_literal: true

class UserInterface
  def self.run
    new.run
  end

  MENU_ACTIONS_ONE = {
    1 => :create_station, 2 => :create_train, 3 => :create_route, 4 => :create_wagon,
    5 => :delete_station, 6 => :delete_train, 7 => :delete_route, 8 => :delete_wagon
  }.freeze

  MENU_ACTIONS_TWO = {
    1 => :delete_station_in_route, 2 => :add_station_in_route, 3 => :set_train_route,
    4 => :add_wagon_train, 5 => :delete_wagon_train, 6 => :travel, 7 => :boarding_loading
  }.freeze

  attr_reader :choice

  def initialize
    @railroad = Railroad.instance
  end

  def info
    return puts "Нет ни одной станции" if @railroad.stations.empty?

    puts "СПИСОК СТАНЦИЙ И ПОЕЗДОВ НА НИХ"
    @railroad.stations.each do |station|
      puts station.station_info
      next if station.trains_at_station.empty?

      station.each_trains do |train|
        puts train.train_info
        train.each_wagons { |wagon| puts wagon.wagon_info }
      end
    end
    puts
  end

  def run
    puts "Добро пожаловать в программу управления железной дорогой v.4"
    loop do
      main_menu
      user_choice
      clear
      case @choice
      when 1
        loop do
          menu_one
          user_choice
          clear
          break if @choice.zero?

          send(MENU_ACTIONS_ONE[@choice])
        end
      when 2
        loop do
          menu_two
          user_choice
          clear
          break if @choice.zero?

          send(MENU_ACTIONS_TWO[@choice])
        end
      when 3
        all_created_objects
      when 4
        info
      when 0
        exit
      else
        puts "Неизвестная команда!"
        puts
      end
    end
  end

  private

  def main_menu
    puts "Введите 1, если хотите создать или удалить станцию, поезд, вагон или маршрут"
    puts "Введите 2, если хотите произвести операции с созданными объектами"
    puts "Введите 3, если хотите вывести текущие данные о объектах"
    puts "Введите 4, если хотите вывести информацию о всех станциях, поездах на них и о вагонах"
    puts "Введите 0, если хотите закончить программу"
  end

  def menu_one
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

  def menu_two
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
      puts @railroad.stations.map(&:name).to_s
      puts
      begin
        puts "Введите имя станции, для выхода введите \"exit\""
        name = gets.chomp
        break if name == "exit"

        Station.new(name)
        puts "Станция \"#{name}\" успешно создана"
      rescue RuntimeError => e
        puts e.message
        retry
      end
    end
    clear
  end

  def delete_station
    loop do
      puts "УДАЛЕНИЕ СТАНЦИЙ!"
      return puts "У вас нет ни одной станции. Создайте станцию!" if @railroad.stations.empty?

      begin
        puts "Список станций:"
        puts @railroad.stations.map(&:name).to_s
        puts
        puts "Введите имя станции, для выхода введите \"exit\""
        name = gets.chomp
        break if name == "exit"

        if @railroad.get_station(name)
          @railroad.stations.delete(@railroad.get_station(name))
          puts "Станция \"#{name}\" удалена"
        else
          puts "Станции \"#{name}\" не существует, выберите станцию из ранее созданных!"
        end
      rescue StandardError => e
        puts "Произошла ошибка #{e.message}. Повторите попытку"
        retry
      end
    end
    clear
  end

  def create_train
    loop do
      puts "СОЗДАНИЕ ПОЕЗДОВ!"
      puts "Список уже существующих поездов:"
      cargo = @railroad.trains.select { |t| t.type == "cargo" }
      passenger = @railroad.trains.select { |t| t.type == "passenger" }
      puts "Грузовые: #{cargo.map(&:number)}"
      puts "Пассажирские: #{passenger.map(&:number)}"
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
      rescue RuntimeError => e
        puts e.message
        retry
      end
    end
    clear
  end

  def delete_train
    return puts "У вас нет ни одного поезда, сначала создайте поезд" if @railroad.trains.empty?

    loop do
      puts "УДАЛЕНИЕ ПОЕЗДОВ!"
      puts "Список поездов:"
      cargo = @railroad.trains.select { |t| t.type == "cargo" }
      passenger = @railroad.trains.select { |t| t.type == "passenger" }
      puts "Грузовые: #{cargo.map(&:number)}"
      puts "Пассажирские: #{passenger.map(&:number)}"
      puts
      begin
        puts "Введите номер поезда, для выхода введите \"exit\""
        number = gets.chomp
        break if number == "exit"

        if @railroad.get_train(number)
          @railroad.trains.delete(@railroad.get_train(number))
          puts "Поезд N #{number} тип: #{type} удален"
        else
          puts "Такого поезда не существует, выберите поезд из ранее созданных!"
        end
        puts
      rescue StandardError => e
        puts e.message
        retry
      end
    end
    clear
  end

  def create_route
    return puts "У вас нет ни одной станции. Сначала создайте станции!" if @railroad.stations.empty?

    starting_station = nil
    terminal_station = nil
    loop do
      puts "СОЗДАНИЕ МАРШРУТА!"
      puts "Список уже существующих маршрутов:"
      puts @railroad.routes.keys.to_s
      puts
      puts "Список уже существующих станций:"
      puts @railroad.stations.map(&:name).to_s
      puts
      print "Введите начальную станцию, для выхода введите \"exit\": "
      starting_station_name = gets.chomp
      break if starting_station_name == "exit"

      starting_station = @railroad.get_station(starting_station_name)
      break if starting_station

      puts "Такой станции нет, выберите станцию из ранее созданных!"
    end
    loop do
      print "Введите конечную станцию, для выхода введите \"exit\": "
      terminal_station_name = gets.chomp
      break if terminal_station_name == "exit"

      terminal_station = @railroad.get_station(terminal_station_name)
      break if terminal_station

      puts "Такой станции нет, выберите станцию из ранее созданных!"
    end

    Route.new(starting_station, terminal_station)
    puts "Маршрут #{starting_station.name}-#{terminal_station.name} успешно создан"
    puts
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def delete_route
    return puts "У вас нет ни одного маршрута, сначала создайте маршрут" if @railroad.routes.empty?

    loop do
      puts "УДАЛЕНИЕ МАРШРУТА!"
      puts "Список маршрутов:"
      puts Route.all_routes.keys.to_s
      puts
      puts "Введите название маршрута который хотите удалить, для выхода введите \"exit\""
      route_name = gets.chomp
      break if route_name == "exit"
      raise "Нет такого маршрута" unless @railroad.routes.key?(route_name)

      @railroad.routes.delete(route_name)
      puts "Маршрут #{route_name} удален"
      puts
    rescue StandardError => e
      puts e.message
      retry
    end
    clear
  end

  def add_station_in_route
    return puts "У вас нет ни одного маршрута, сначала создайте маршрут" if @railroad.routes.empty?

    return puts "У вас нет ни одной станции, сначала создайте станцию" if @railroad.stations.empty?

    loop do
      puts "ДОБАВЛЕНИЕ СТАНЦИЙ В МАРШРУТ!"
      puts "Список маршрутов:"
      puts @railroad.routes.keys.to_s
      puts
      puts "Введите назнание маршрута, для выхода введите \"exit\""
      route_name = gets.chomp
      break if route_name == "exit"
      raise "Нет такого маршрута" unless @railroad.routes[route_name]

      puts "Список станций:"
      puts @railroad.stations.map(&:name).to_s
      puts
      puts "Введите имя станции которую хотите добавить в маршрут:"
      station_name = gets.chomp
      raise "Нет такой станции" unless @railroad.stations.include?(@railroad.get_station(station_name))

      if @railroad.routes[route_name].add_station(@railroad.get_station(station_name))
        puts "Станция #{station_name} успешно добавлена в маршрут #{route_name}"
      else
        puts "Такая станция уже есть в маршруте"
      end
    rescue StandardError => e
      puts e.message
      retry
    end
    clear
  end

  def delete_station_in_route
    return puts "У вас нет ни одного маршрута, сначала создайте маршрут" if @railroad.routes.empty?

    return puts "У вас нет ни одной станции, сначала создайте станцию" if @railroad.stations.empty?

    loop do
      puts "УДАЛЕНИЕ СТАНЦИЙ ИЗ МАРШРУТА!"
      puts "Список маршрутов:"
      puts @railroad.routes.keys.to_s
      puts
      puts "Введите назнание маршрута, для выхода введите \"exit\""
      route_name = gets.chomp
      break if route_name == "exit"
      raise "Нет такого маршрута" unless @railroad.routes[route_name]

      puts "Список станций по маршруту #{route_name}:"
      puts @railroad.routes[route_name].all_stations.map(&:name).to_s
      puts
      puts "Введите имя станции"
      station_name = gets.chomp
      if @railroad.routes[route_name].delete_station(@railroad.get_station(station_name))
        puts "Станция #{station_name} успешно удалена из маршрута #{route_name}"
      else
        puts "Такой станции нет в маршруте"
      end
    rescue StandardError => e
      puts e.message
      retry
    end
    clear
  end

  def add_wagon_train
    return puts "Нет вагонов! Сначала создайте вагон." if @railroad.wagons.empty?

    return puts "Нет поездов! Создайте их." if @railroad.trains.empty?

    loop do
      puts "ДОБАВЛЕНИЕ ВАГОНОВ К ПОЕЗДАМ!"
      puts "Список поездов:"
      cargo = @railroad.trains.select { |t| t.type == "cargo" }
      passenger = @railroad.trains.select { |t| t.type == "passenger" }
      puts "Грузовые: #{cargo.map(&:number)}"
      puts "Пассажирские: #{passenger.map(&:number)}"
      puts
      puts "Введите номер поезда, для выхода введите \"exit\""
      number = gets.chomp
      break if number == "exit"
      raise "Такого поезда нет, выберите из ранее созданных!" unless @railroad.get_train(number)

      puts "Список вагонов:"
      puts @railroad.wagons.map(&:number).to_s
      puts
      puts "Введите номер вагона который хотите добавить:"
      wagon_number = gets.chomp
      raise "Вагон №#{wagon_number} не найден" unless @railroad.get_wagon(wagon_number)

      if @railroad.get_train(number).add_wagon(@railroad.get_wagon(wagon_number))
        @railroad.wagons.delete(@railroad.get_wagon(wagon_number))
        puts "Вагон успешно добавлен к поезду"
      else
        puts "Не удалось выполнить операцию."
        puts "Остановите поезд: #{@railroad.get_train(number).speed}км/ч"
        puts "проверьте корректность типа поезда и типа вагона"
      end
      puts
    rescue StandardError => e
      puts e.message
      retry
    end
    clear
  end

  def delete_wagon_train
    return puts "Нет поездов! Создайте их." if @railroad.trains.empty?

    loop do
      puts "ОТЦЕПЛЕНИЕ ВАГОНОВ!"
      puts "Список поездов:"
      cargo = @railroad.trains.select { |t| t.type == "cargo" }
      passenger = @railroad.trains.select { |t| t.type == "passenger" }
      puts "Грузовые: #{cargo.map(&:number)}"
      puts "Пассажирские: #{passenger.map(&:number)}"
      puts
      puts "Введите номер поезда, для выхода введите \"exit\""
      number = gets.chomp
      break if number == "exit"
      raise "Такого поезда нет, выберите из ранее созданных!" unless @railroad.get_train(number)

      if wagon = (@railroad.get_train(number).remove_wagon)
        @railroad.wagons << wagon
        puts "Вагон успешно отцеплен от поезда N #{number}"
        puts "Оставшееся кол-во вагонов в составе #{@railroad.get_train(number).amount_wagons}"
      else
        puts "Не удалось выполнить операцию."
        puts "Остановите поезд: #{@railroad.get_train(number).speed}км/ч"
        puts "Колличество вагонов в составе = #{@railroad.get_train(number).amount_wagons}"
      end
      puts
    rescue StandardError => e
      puts e.message
      retry
    end
    clear
  end

  def set_train_route
    return puts "Сначала создайте поезд!" if @railroad.trains.empty?

    return puts "Создайте маршрут!" if @railroad.routes.empty?

    loop do
      puts "НАЗНАЧЕНИЕ МАРШРУТА ПОЕЗДАМ!"
      puts "Список поездов:"
      cargo = @railroad.trains.select { |t| t.type == "cargo" }
      passenger = @railroad.trains.select { |t| t.type == "passenger" }
      puts "Грузовые: #{cargo.map(&:number)}"
      puts "Пассажирские: #{passenger.map(&:number)}"
      puts
      puts "Введите номер поезда, для выхода введите \"exit\""
      number = gets.chomp
      break if number == "exit"

      puts "Список маршрутов:"
      puts @railroad.routes.keys.to_s
      puts
      puts "Введите имя маршрута на который установить поезд:"
      route_name = gets.chomp
      if @railroad.get_train(number) && @railroad.routes.key?(route_name)
        @railroad.get_train(number).set_route(@railroad.routes[route_name])
        puts "Поезд № #{number} установлен на маршрут #{route_name}"
        puts "Текущая станция - #{@railroad.get_train(number).current_station.name}"
      else
        puts "Некорректные данные, попробуйте снова!"
      end
      puts
    end
    clear
  end

  def create_wagon
    loop do
      puts "СОЗДАНИЕ ВАГОНОВ!"
      puts "Список вагонов в депо:"
      cargo_wagons = @railroad.wagons.select { |w| w.type == "cargo" }
      passenger_wagons = @railroad.wagons.select { |w| w.type == "passenger" }
      puts "Грузовые: #{cargo_wagons.map(&:number)}"
      puts "Пассажирские: #{passenger_wagons.map(&:number)}"
      puts
      puts "Создать пассажирский вагон введите-\"passenger\"; грузовой-\"cargo\" выйти-\"exit\""
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
      when "cargo"
        puts "Укажите номер вагона:"
        number = gets.chomp
        puts "Укажите общий объем:"
        total_volume = gets.chomp.to_f
        CargoWagon.new(wagon_type, number, total_volume)
        puts "Грузовой вагон № #{number} успешно создан"
      else
        puts "Неверно указан тип вагона, попробуйте снова"
      end
      puts
    rescue RuntimeError => e
      puts e.message
      retry
    end
    clear
  end

  def delete_wagon
    return puts "У вас нет ни одного вагона" if @railroad.wagons.empty?

    loop do
      puts "УДАЛЕНИЕ ВАГОНОВ!"
      puts "Список вагонов в депо:"
      cargo_wagons = @railroad.wagons.select { |w| w.type == "cargo" }
      passenger_wagons = @railroad.wagons.select { |w| w.type == "passenger" }
      puts "Грузовые: #{cargo_wagons.map(&:number)}"
      puts "Пассажирские: #{passenger_wagons.map(&:number)}"
      puts
      puts "Введите номер вагона, для выхода введите - \"exit\""
      wagon_number = gets.chomp
      break if wagon_number == "exit"

      if @railroad.get_wagon(wagon_number)
        @railroad.wagons.delete(@railroad.get_wagon(wagon_number))
        puts "Вагон #{wagon_number} успешно удален"
      else
        puts "Нет такого вагона в депо"
      end
      puts
    end
    clear
  end

  def boarding_loading
    loop do
      begin
        puts "ПОСАДКА/ПОГРУЗКА НА ВАГОНЫ!"
        puts "Список поездов:"
        cargo = @railroad.trains.select { |t| t.type == "cargo" }
        passenger = @railroad.trains.select { |t| t.type == "passenger" }
        puts "Грузовые: #{cargo.map(&:number)}"
        puts "Пассажирские: #{passenger.map(&:number)}"
        puts
        puts "Введите номер поезда для выхода введите - \"exit\""
        train_number = gets.chomp
        break if train_number == "exit"

        unless @railroad.wagons.empty?
          puts "Не добавленные вагоны к поездам: #{@railroad.wagons.map(&:number)}"
        end
        puts "Вагоны в составе поездa #{train_number}:"
        @railroad.get_train(train_number).wagons.each { |wagon| puts "Вагон № #{wagon.number}" }
      rescue NoMethodError
        puts "Не верно указан номер поезда, повторите попытку"
        retry
      end
      puts "Введите номер вагона:"
      wagon_number = gets.chomp
      if @railroad.get_wagon(wagon_number)
        puts "Сначала прицепите вагон к поезду"
      elsif @railroad.get_train(train_number).get_wagon(wagon_number).nil?
        puts "Нет вагона с таким номером"
      elsif @railroad.get_train(train_number).type == "passenger"
        @railroad.get_train(train_number).get_wagon(wagon_number).take_a_seat
        puts "Пассажир занял свое место в вагоне"
        puts
      elsif @railroad.get_train(train_number).type == "cargo"
        puts "Введите объем груза(m3):"
        volume = gets.chomp.to_f
        @railroad.get_train(train_number).get_wagon(wagon_number).upload(volume)
        puts "Погрузка прошла успешно"
        puts
      end
    rescue RuntimeError => e
      puts e.message
      retry
    end
    clear
  end

  def travel
    return puts "Сначала создайте поезд" if @railroad.trains.empty?

    loop do
      puts "ПЕРЕМЕЩЕНИЕ ПОЕЗДА ПО МАРШРУТУ!"
      puts "Список поездов:"
      cargo = @railroad.trains.select { |t| t.type == "cargo" }
      passenger = @railroad.trains.select { |t| t.type == "passenger" }
      puts "Грузовые: #{cargo.map(&:number)}"
      puts "Пассажирские: #{passenger.map(&:number)}"
      puts
      puts "Введите номер поезда, для выхода введите - \"exit\""
      number = gets.chomp
      break if number == "exit"
      raise "Нет такого поезда, проверьте данные" unless @railroad.get_train(number)

      return puts "Не задан маршрут для данного поезда" if @railroad.get_train(number).route.nil?

      loop do
        puts "Следующая станция-\"next\",предыдущая-\"back\",сменить поезд введите \"exit\""
        choice = gets.chomp
        break if choice == "exit"

        case choice
        when "next"
          if @railroad.get_train(number).go_ahead
            puts "Поезд №#{number} прибыл на станцию - " \
            "#{@railroad.get_train(number).current_station.name}"
          else
            puts "Поезд №#{number} на конечной станции - " \
            "#{@railroad.get_train(number).current_station.name}"
          end
        when "back"
          if @railroad.get_train(number).go_back
            puts "Поезд № #{number} прибыл на станцию - " \
            "#{@railroad.get_train(number).current_station.name}"
          else
            puts "Поезд № #{number} на начальной станции - " \
            "#{@railroad.get_train(number).current_station.name}"
          end
        else
          puts "Неверно введенные данные, попробуйте снова"
        end
      end
    rescue StandardError => e
      puts e.message
      retry
    end
    clear
  end

  def list_station
    return puts "Нет ни одной станции" if @railroad.stations.empty?

    puts "СПИСОК СТАНЦИЙ И ПОЕЗДОВ НА НИХ"
    @railroad.stations.each do |station|
      puts "Станция - #{station.name}; поездов на станции - #{station.trains_at_station.size}"
      next if station.trains_at_station.empty?

      station.trains_at_station.each do |train|
        puts "Поезд № #{train.number}; тип - #{train.type}"
      end
    end
  end

  def list_trains
    return puts "Нет ни одного поезда" if @railroad.trains.empty?

    puts "СПИСОК СОЗДАННЫХ ПОЕЗДОВ"
    @railroad.trains.each { |train| puts "Поезд № #{train.number}, тип: #{train.type}" }
  end

  def list_routes
    return puts "Нет ни одного маршрута" if @railroad.routes.empty?

    puts "СПИСОК СОЗДАННЫХ МАРШРУТОВ"
    @railroad.routes.each_key { |route| puts "Маршрут: #{route}" }
  end

  def list_wagons
    return puts "Нет ни одного вагона" if @railroad.wagons.empty?

    puts "СПИСОК СОЗДАННЫХ ВАГОНОВ"
    @railroad.wagons.each { |wagon| puts "#{wagon.number} #{wagon.type}" }
  end

  def all_created_objects
    list_station
    list_trains
    list_routes
    list_wagons
  end
end
