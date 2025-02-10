# Ruby Product Crawler

## 📋 Project Overview


This project was developed to assist my client in **migrating product data** from an old website to a new one. The crawler scrapes product information such as titles, prices, catalog numbers, stock statuses, descriptions, and images from a specified website. The scraped data is then saved to a CSV file, allowing for easy import into the new system.

## Requirements for classes
3.0 Należy pobrać podstawowe dane o produktach (tytuł, cena), dowolna kategoria +
3.5 Należy pobrać podstawowe dane o produktach wg słów kluczowych +
4.0 Należy rozszerzyć dane o produktach o dane szczegółowe widoczne tylko na podstronie o produkcie +
4.5 Należy zapisać linki do produktów +

The website used in this crawler is `https://tkaninydzieciece.com.pl/`.

## How It Works

The **Ruby web crawler** uses the following technologies:
- **Ruby** as a main programming language
- **Nokogiri** for parsing HTML and scraping data.
- **Open-URI** for fetching pages over HTTP.

### What the Crawler Does
1. **Iterates through all pages** of the product listings on the source website.
2. Extracts product details such as:
   - Title
   - Catalog number
   - Specifications
   - Price
   - Stock status
   - Description
   - Images
3. **Downloads all available product images** and saves them locally.
4. **Saves the extracted data** into a `products.csv` file and images in separate folder.

##  Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/Ruby_Crawler.git
   cd Ruby_Crawler
   gem install nokogiri
   ruby nokogiri.rb

