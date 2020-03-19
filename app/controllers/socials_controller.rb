class SocialsController < ApplicationController
  before_action :set_social, only: [:show, :edit, :update, :destroy]
  require 'mechanize'
  require 'nokogiri'
  require 'open-uri'

  def index
    @q = Social.ransack(params[:q])
    @socials = @q.result(distinct: true).order(id: :desc).paginate(page: params[:page], per_page: 10)
  end

  def new
    @social = Social.new
  end

  def create
    initial = 'http://mds.gov.br/area-de-imprensa/noticias'
    social_content = Nokogiri::HTML(open(initial))
    pag = social_content.search('#content')
    latest_index = pag.css('.pagina').text

    count = 0

      (0..latest_index).each do |index|
      url = "http://mds.gov.br/area-de-imprensa/noticias?b_start:int=#{count}"
      social_html = open(url).read
      doc = Nokogiri::HTML(social_html)
      news = doc.search('#content-core').css('.summary').map { |e| e['href'] }

      count += 12

      item = {}
        news.each do |url|
          doc = Nokogiri::HTML(open(url))
          item[:source] = 'Desenvolvimento Social'
          item[:url] = url
          item[:title] = doc.css(".documentFirstHeading").text
          item[:subtitle] = doc.css(".documentDescription").text
          item[:body] = doc.css("div[property='rnews:articleBody']").text
          item[:publication] = doc.css(".documentPublished").text.squish.gsub('publicado em', '')
          item[:tags] = doc.css(".link-category").map(&:text).join(', ')
          Crawler.where(item).first_or_create
          Social.where(item).first_or_create
        end
      end
  end

  private

    def set_social
      @social = Social.find(params[:id])
    end

    def social_params
      params.require(:social).permit(:source, :url, :title, :subtitle, :publication, :body, :tags)
    end
end
