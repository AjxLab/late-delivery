# -*- coding:utf-8 -*-
require 'io/console'
require 'yaml'


def getpass(prompt:["id", "password"], is_echo:[true, false],
            display_tail: true, sub_char:"*")
  ## -----*----- パスワード入力 -----*----- ##
  raise ArgumentError unless prompt.length == is_echo.length
  ret = Array.new(prompt.length)

  prompt.length.times do |i|
    print "#{prompt[i]}："
    ret[i] = ''

    # エコーバック無し
    STDIN.noecho {
      i_backspace = 0

      loop do
        c = STDIN.raw(&:getc)
        # 改行
        break if c == "\r"

        # Backspace
        if c == "\u007F"
          unless is_echo[i]
            print "\e[2D  \e[1D"  unless ret[i]==''
          else
            print "\e[1D \e[1D"  unless ret[i]==''
          end
          ret[i].chop!
          next
        end

        ret[i] += c
        if is_echo[i]
          putc c
        else
          if display_tail
            # 末尾のみ表示・その他はsub_charに置換
            sub_str = sub_char * (ret[i].length-1) + ret[i][-1]
            print "\e[#{ret[i].length}D#{sub_str}\e[1C"
          else
            putc sub_char
          end
        end
      end
    }
    print "\n"
  end

  ret
end


namespace :setup do
  desc 'Gmail Settings'
  task :gmail do
    puts "1. Enter your address to send."
    send = getpass(prompt: ["Gmail Address", "Application Password"])
    puts ""
    puts "2. Enter your address to receive."
    receive = getpass(prompt: ["Gmail Address"], is_echo: [true])

    data = {
      send:    {address: send[0], password: send[1]},
      receive: {address: receive[0]}
    }
    YAML.dump(data, File.open('config/mail.yml', 'w'))

    puts ""
    puts "Successful to setup Gmail."
  end

  desc 'LINE Settings'
  task :line do
    puts "Enter your LINE access token."
    token = getpass(prompt: ["TOKEN"], is_echo: [true])
    File.open('config/line_token', 'w').write(token[0])

      puts ""
    puts "Successful to setup LINE."
  end
end
