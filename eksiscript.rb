require 'open-uri'
require 'nokogiri'

puts "Lütfen yorumlarında anahtar kelime aramak istediğiniz başlığın linkini giriniz."
puts "Not: başlığı gündemin içinden seçmeniz gerekmektedir."
pattern = "\Ahttps?:\/\/(www)?eksisozluk.com\/.+"
input = gets.chomp

#checks whether the link is valid
while (input != "1") && ((/\Ahttps?:\/\/(www)?eksisozluk.com\/.+/ =~ input) == nil)
  puts "Bu geçerli bir ekşisözlük gündem linki değil, lütfen bir daha deneyin veya
  çıkmak için 1'e basın"
  input = gets.chomp
end

#if the user types 1 , exits the program
if input != "1"

  puts "Şimdi lütfen aratmak istediğiniz anahtar kelimeyi giriniz"
  keyword = gets.chomp
  counter = 0

  #gets the HTML content of the page then parses it to get info
  #such as page number, keyword, author, date, comment etc.
  doc = Nokogiri::HTML(open(input))
  page_number = doc.css('#topic .pager').attribute("data-pagecount").value.to_i

  puts "Anahtar kelimeyi içeren yorumlar taranıyor..."
  1.upto(page_number) {
    |i|
    input_page = input + "&p=#{i}"
    doc = Nokogiri::HTML(open(input_page))
    topic = doc.css('#topic li')

    #iterate over each comment in the page to see it contains the keyword
    topic.each do |comment|
      author = comment.attribute("data-author")
      date = comment.css('footer .info .entry-date').text
      text = comment.css('.content').text.strip

      if text.include? keyword
        counter += 1
        puts "Yazar: " + author
        puts "Tarih: " + date
        puts "Yorum: " + text
        puts "======================================================================="
      end
    end
  }
  #warns the user if no keyword is found in any comment
  puts "Aramanıza uygun içerik bulunamadı :(" if counter == 0
end
