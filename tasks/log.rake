namespace :log do
  desc 'Clear Log Files'
  task :clear do
    # ログをリセット
    File.open('./log/develop.log', 'w')

    puts 'Successful to delete log!!'
  end
end
