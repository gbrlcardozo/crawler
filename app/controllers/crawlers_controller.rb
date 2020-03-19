class CrawlersController < ApplicationController
  before_action :set_crawler, only: [:show, :edit, :update, :destroy]

  def index
    @q = Crawler.ransack(params[:q])
    @crawlers = @q.result(distinct: true).order(id: :desc).paginate(page: params[:page], per_page: 10)
  end

  private

    def set_crawler
      @crawler = Crawler.find(params[:id])
    end

    def crawler_params
      params.require(:crawler).permit(:source, :url, :title, :subtitle, :publication, :body, :tags)
    end
end
