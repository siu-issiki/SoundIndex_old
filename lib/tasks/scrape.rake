# URLにアクセスするためのライブラリの読み込み
require 'open-uri'

namespace :scrape do

  desc 'NaverまとめのTechページからタイトルを取得'
  task :m3 => :environment do
    # スクレイピング先のURL
    url = 'http://www.m3net.jp/attendance/circle2018f'

    charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end

    # htmlをパース(解析)してオブジェクトを作成
    doc = Nokogiri::HTML.parse(html, nil, charset)

    table = doc.xpath('//table[@class="tblCircleList"]')
    table.xpath('//tr').each do |tr|
      circle = Circle.new
      if tr.css('a').present?
        puts "#{tr.css('a')[0].inner_text.strip} : #{tr.css('td.right').inner_text.strip}"
        circle.name = tr.css('a')[0].inner_text.strip
        circle.description = tr.css('td.right').inner_text.strip
      else
        puts "#{tr.css('ul').inner_text.strip} : #{tr.css('td.right').inner_text.strip}"
        circle.name = tr.css('ul').inner_text.strip
        circle.description = tr.css('td.right').inner_text.strip
      end
      circle.save!
    end
  end

end