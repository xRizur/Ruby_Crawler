require 'nokogiri'
require 'uri'
require 'open-uri'
require 'csv'
require 'fileutils'

class ProductCrawler
  BASE_SEARCH_URL = 'https://tkaninydzieciece.com.pl/szukaj'
  BASE_URL = 'https://tkaninydzieciece.com.pl/'

  def initialize
    @data = []
  end

  def fetch_all_products
    page_number = 1

    loop do
      page_url = "#{BASE_SEARCH_URL},#{page_number}"
      puts "Pobieranie strony: #{page_url}"

      page = fetch_page(page_url)
      break unless page # Jeśli strona nie zostanie pobrana, przerywamy

      products = scrape_products(page)
      break if products.empty? # Jeśli nie ma więcej produktów, kończymy

      products.each do |product|
        fetch_product_details(product[:detail_link], product[:title], product[:price])
      end

      page_number += 1 # Przechodzimy do następnej strony
    end

    save_to_csv
  end

  private

  def fetch_page(url)
    html = URI.open(url).read
    Nokogiri::HTML(html)
  rescue OpenURI::HTTPError => e
    puts "Błąd pobierania strony: #{e.message}"
    nil
  end

  def scrape_products(page)
    return [] unless page
    product_elements = page.css('.produkt_box')

    product_elements.map do |product|
      begin
        title_element = product.at_css('.produkt_box_tytul a')
        title = title_element.text.strip
        detail_link = title_element['href']
        
        # Dodanie ukośnika, jeśli brakuje go w URL-u
        detail_link = detail_link.start_with?('/') ? "#{BASE_URL}#{detail_link[1..]}" : "#{BASE_URL}#{detail_link}"
        
        price = product.at_css('.produkty_box_stopka1 span.cena').text.strip

        { title: title, price: price, detail_link: detail_link }
      rescue => e
        puts "Błąd podczas pobierania danych produktu: #{e.message}"
        next
      end
    end.compact
  end

  def fetch_product_details(url, title, price)
    puts "Pobieranie szczegółów produktu: #{title}"
    page = fetch_page(url)
    return unless page

    begin
      catalog_number = get_catalog_number(page)
      stock_status = get_stock_status(page)
      description = get_description(page)
      specifications = get_specifications(page)

      download_images(page, title)

      @data << {
        title: title,
        catalog_number: catalog_number,
        specifications: specifications,
        price: price,
        stock_status: stock_status,
        description: description,
        url: url
      }
    rescue => e
      puts "Błąd podczas pobierania szczegółów: #{e.message}"
    end
  end

  def download_images(page, title)
    image_elements = page.css('.pokaz-produkt-zdj a')
    FileUtils.mkdir_p('images')

    image_elements.each_with_index do |image, index|
      image_url = image['href']
      image_url = image_url.start_with?('/') ? "#{BASE_URL}#{image_url[1..]}" : "#{BASE_URL}#{image_url}"
      filename = "images/#{sanitize_filename(title)}_#{index + 1}.jpg"
      download_image(image_url, filename)
    end
  end

  def download_image(url, filename)
    puts "Pobieranie zdjęcia: #{url} -> #{filename}"
    URI.open(url) do |image|
      File.open(filename, 'wb') do |file|
        file.write(image.read)
      end
    end
  rescue => e
    puts "Błąd pobierania zdjęcia: #{e.message}"
  end

  def get_catalog_number(page)
    catalog_info = page.xpath("//text()[contains(., 'nr katalogowy')]").first
    if catalog_info
      catalog_number = catalog_info.parent.at('strong')&.text&.strip
      catalog_number || "Brak numeru"
    else
      "Brak numeru"
    end
  end

  def get_stock_status(page)
    stock_info = page.at_css('div[style="text-align: center;"]')
    stock_info ? stock_info.text.split(":").last.strip : "Brak informacji"
  end

  def get_description(page)
    description_element = page.at_css('.produkt_box_tresc')
    description_element ? description_element.text.strip : "Brak opisu"
  end

  def get_specifications(page)
    specs = page.css('p').map(&:text).join(' ').strip
    specs.empty? ? "Brak specyfikacji" : specs
  end

  def sanitize_filename(filename)
    filename.gsub(/[^\w\s_-]+/, '').gsub(/\s+/, '_')
  end

  def save_to_csv
    CSV.open("products.csv", "w", write_headers: true, headers: ["Tytuł", "Numer katalogowy", "Specyfikacja", "Cena", "Stan magazynowy", "Opis", "Link"]) do |csv|
      @data.each do |row|
        csv << row.values
      end
    end
    puts "Dane zapisano do pliku products.csv"
  end
end

# Uruchomienie skryptu
crawler = ProductCrawler.new
crawler.fetch_all_products
