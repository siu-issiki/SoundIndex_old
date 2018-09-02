# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
require 'uri'

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
        circle.name = tr.css('a')[0].inner_text.strip
        tr.css('.dropmenu2 > li > ul > li > a').each do |link_node|
          link = link_node.inner_text.strip
          begin
            base = Addressable::URI.parse(link).host
          rescue => e
            p e
            next
          end
          case base
          when "twitter.com" then
            circle.twitter_url = link
          when "soundcloud.com" then
            circle.soundcloud_url = link
          when "www.youtube.com" then
            circle.youtube_url = link
          when "www.nicovideo.jp" then
            circle.niconico_url = link
          when nil then
            next
          else
            circle.homepage_url = link
          end

        end
      else
        circle.name = tr.css('ul').inner_text.strip
      end
      circle.description = tr.css('td.right').inner_text.strip
      circle.save!
    end
  end

end