require 'open-uri'

def webDL(link, file)
  ## -----*----- Webからダウンロード -----*----- ##
  FileUtils.mkdir_p(File.dirname(file)) unless FileTest.exist?(File.dirname(file))
  begin
    open(file, 'wb') do |local_file|
      URI.open(link) do |web_file|
        local_file.write(web_file.read)
      end
    end

  rescue => e
    $logger.error(e.to_s)
  end
end


def scraping(doc, delay: 3, depth_limit: nil)
  ## -----*----- スクレイピング -----*----- ##

  # DBにレコードを追加
  # $model.<table>.create(col1: value, col2: value...)

  # メールにアラートを出す
  # send_mail(to_address, subject, body)

  # ログ出力
  # $logger.<level>('log text')
end
