class CulturesController < ApplicationController
  before_action :set_culture, only: [:show, :edit, :update, :destroy]
  require 'mechanize'
  require 'nokogiri'
  require 'open-uri'

  def index
    @q = Culture.ransack(params[:q])
    @cultures = @q.result(distinct: true).order(id: :desc).paginate(page: params[:page], per_page: 10)
  end

  def new
    @culture = Culture.new
  end

  def create()
      initial = 'http://cultura.gov.br/categoria/noticias/'
      culture_content = Nokogiri::HTML(open(initial))
      pag = culture_content.search('#posts-list')
      get_last_index = pag.css('.page-link').map { |e| e['href']  }.compact
      get_max = get_last_index.max
      latest_index = get_max.scan(/\d/).join('').to_i

      (1..latest_index).each do |index|
        url = "http://cultura.gov.br/categoria/noticias/page/#{index}/"
        culture_html = open(url).read
        doc = Nokogiri::HTML(culture_html)
        news = doc.search('#posts-list').css('[id^="post-"]').css('h2').css('a').map { |e| e['href'] }

        item = {}
          news.each do |url|
            doc = Nokogiri::HTML(open(url))
            item[:source] = 'Cultura'
            item[:url] = url
            item[:title] = doc.css(".entry-title").text
            item[:subtitle] = doc.css(".subtitle-single").text
            item[:body] = doc.css(".entry-content").css('p:not(:last-of-type)').text
            item[:publication] = doc.css(".date-box").text.squish.gsub('publicado:', '')
            Crawler.where(item).first_or_create
            Culture.where(item).first_or_create
        end
     end
  end

  private

    def set_culture
      @culture = Culture.find(params[:id])
    end

    def culture_params
      params.require(:culture).permit(:source, :url, :title, :subtitle, :publication, :body, :tags)
    end
end
