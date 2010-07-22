namespace :application do

  namespace :init do
    desc 'Initialize clients'
    task :clients => :environment do
      init_clients
    end
  end

  namespace :init do
    desc 'Initialize admin user'
    task :admin => :environment do
      init_admin_user
    end
  end

  namespace :dev do
    desc 'Initialize normal user'
    task :init_user => :environment do
      init_user
    end
  end

  namespace :dev do
    desc 'Initialize events'
    task :init_events => :environment do
      init_events
    end
  end

  namespace :dev do
    desc 'Initialize all'
    task :init_all => :environment do
      init_clients
      init_events
      init_admin_user
      init_user
    end
  end

  namespace :init do
    desc 'Initialize everything'
    task :all => :environment do
      init_admin_user
      init_clients
    end
  end
  
private

  def init_clients

    require 'csv'

    reader = CSV.open('lib/tasks/clients.csv', 'r')
    header = reader.shift

    columns = {}
    composed_columns = {:name => 'surname'}
    Client.columns.each {|c| columns[c.name.to_sym] = header.index(c.name.downcase) unless header.index(c.name.downcase).nil?}

    reader.each do |row|
      client = Client.new
      columns.keys.each do |key|
        value = row[columns[key]]
        value = '' if value.blank?

        composed_value = row[header.index(composed_columns[key.to_sym])].to_s unless composed_columns[key.to_sym].blank?
        value += " #{composed_value}" unless composed_value.blank?
        client.write_attribute(key, value)
      end
      if client.save
        puts "client #{client.name} saved" rescue 'client saved'
      end
    end
  end

  def init_admin_user
    u = User.find_or_initialize_by_login 'admin'
    u.email = 'admin@mail.com'
    u.password = '123456' if u.new_record?
    u.password_confirmation = '123456' if u.new_record?
    u.is_admin = true
    u.state = 'active'
    if u.save
      puts 'admin user initialized'
    else
      puts 'error while initializing admin user'
    end
  end

  def init_user
    u = User.find_or_initialize_by_login 'user'
    u.email = 'user@mail.com'
    u.password = '123456' if u.new_record?
    u.password_confirmation = '123456' if u.new_record?
    u.is_admin = false
    u.state = 'active'
    if u.save
      puts 'admin user initialized'
    else
      puts 'error while initializing admin user: ' + u.errors.full_messages.join('\n')
    end
  end

  def init_events
    events_count = 5

    events_count.times do |i|
      e = Event.find_or_initialize_by_id(i + 1)
      e.client_id = i + 1
      e.name = "Event #{i + 1}"
      e.description = "Description for event #{i + 1}"
      e.address = "Address for event #{i + 1}"
      e.resources = i + 1
      e.start_at = (Time.now + (60 * 60 * 24) * i).strftime('%d/%m/%Y %H:%M')
      e.end_at = (Time.now + (60 * 60 * 24) * i + (60 * 60 *3)).strftime('%d/%m/%Y %H:%M')
      if e.save
        puts "Event #{i + 1} created"
      end
    end
  end
end


