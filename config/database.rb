require 'pg'
require 'yaml'
require 'date'

class Database
  def self.connection
    PG.connect(environment_db_params)
  rescue PG::Error => e
    raise e.message
  end

  def self.environment_db_params
    data = File.read('config/database.yml')

    db = YAML.safe_load(data, aliases: true)

    db[ENV['DATABASE']] || db['development']
  end

  def self.call(args)
    args.map! { |arg| arg.gsub(':', '_').to_sym }
    self.send(*args)
  end

  def self.create_db(database = environment_db_params['dbname'])
    puts `createdb #{database}`# -U postgres`
  end

  def self.drop_db(database = environment_db_params['dbname'])
    puts `dropdb #{database}`# -U postgres`
  end

  def self.create_migration(name)
    time_stamp = DateTime.now.strftime('%Y%m%d%H%M%S%L')
    file_name = name.to_s.to_underscore

    File.open("#{File.dirname(__FILE__)}/../db/migrations/#{time_stamp}_#{file_name}.rb", 'w+') do |file|
      migration = <<~EOF
        class #{name}
          def self.migrate

            sql = <<~SQL
              CREATE TABLE examples (
                id SERIAL PRIMARY KEY,
                name varchar(255) NOT NULL,
                created_at date NOT NULL,
                updated_at date NOT NULL
              )
            SQL


            connection = Database.connection
            connection.exec(sql)
            connection&.close
          end
        end

        #{name}.migrate
      EOF

      file.write(migration)
    end
  end

  def self.migrate
    migrations = Dir["#{File.dirname(__FILE__)}/../db/migrations/*.rb"]

    migrations.each do |migration|
      puts "=== Migrating: #{migration.split('/').last} ==="

      starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      require migration
      engind = Process.clock_gettime(Process::CLOCK_MONOTONIC)

      elapsed = engind - starting
      elapsed = Time.at(elapsed).gmtime.strftime('%T%L')

      puts "=== Migrated: #{elapsed} ==="
    end
  end
end
