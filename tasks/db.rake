## -----*----- データベース操作 -----*----- ##
require './model'


config = YAML.load_file('config/db.yml')
model = Model.new config['file']


namespace :db do
  desc 'Migrate Database'
  task :migrate do

    # テーブル作成
    config['tables'].each do |table|
      table = table.flatten
      next  if model.tables.include?(table[0])

      model.create_table(table[0]) { |t|
        table[1].each { |col|
          name = col['name'].to_s
          name = ":#{name}"  unless name==''
          opts = col['opts'].to_a.join(',')
          opts = ", #{opts}"  unless opts==''
          eval("t.#{col['type']} #{name}#{opts}")
        }
      }
    end

    puts 'Successful to migrate database!!'
  end

  desc 'Clear Database'
  task :clear do
    File.open('./db/develop.sqlite3', 'w')

    puts 'Successful to clear database!!'
  end

  model.tables.each do |table|
    desc "Clear #{table} Table"
    task "clear_#{table}".to_sym do
      model.drop_table(table)
      puts "Successful to clear #{table} table!!"
    end
  end
end