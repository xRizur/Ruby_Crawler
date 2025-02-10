# Ruby Product Crawler

## 📋 Project Overview


This project was developed to assist my client in **migrating product data** from an old website to a new one. The crawler scrapes product information such as titles, prices, catalog numbers, stock statuses, descriptions, and images from a specified website. The scraped data is then saved to a CSV file, allowing for easy import into the new system.

## Requirements for classes
I done every requirements for 4.5. Data is saved to csv with links, specific data from single product and based on keywords. Additional i download all images but didn't post it to repo -it's almost 1000.

The website used in this crawler is `https://tkaninydzieciece.com.pl/`.

## How It Works

The **Ruby web crawler** uses the following technologies:
- **Ruby** as a main programming language
- **Nokogiri** for parsing HTML and scraping data.

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

