def connect_gmail(file: 'config/mail.yml')
  ## -----*----- Gmailアカウント -----*----- ##
  begin
    account = YAML.load_file(file)
  rescue => error
    puts "\e[31m#{error}\e[0m"
    puts 'Please set up gmail by executing the following command.'
    puts '$ bundle exec rake setup:gmail'

    footer_exit status: 1
  end

  ## Connect Gmail with Application Password
  $gmail = Gmail.new(account[:send][:address], account[:send][:password])
end


def send_mail(to_address, _subject, _body)
  ## -----*----- メール送信 -----*----- ##
  # to_address；送信先のアドレス
  # title：メールタイトル
  # sentence：メール本文

  # Gmailオブジェクトが未生成
  connect_gmail unless defined? $gmail

  message = $gmail.generate_message {
    to to_address
    subject _subject
    html_part {
      content_type "text/html; charset=UTF-8"
      body _body
    }
  }

  $gmail.deliver(message)
end


def send_line(msg)
  ## -----*----- LINE -----*----- ##
  token = File.open('config/line_token', 'r').read()
  uri = URI.parse("https://notify-api.line.me/api/notify")
  request = Net::HTTP::Post.new(uri)
  request["Authorization"] = "Bearer #{token}"
  request.set_form_data(message: msg)

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |https|
    https.request(request)
  end
end

