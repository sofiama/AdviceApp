class AdvicesController < ApplicationController
  require 'open-uri'
  require 'nokogiri'

  def new
    @advice = Advice.new
  end

  def create
    @advice = Advice.find_or_create_by(url: params["advice"]["url"])
    if @advice
      @advice.tag_list.add(params["advice"]["tag_list"], :parse => true)
      @advice.save
      current_user.user_advices.find_or_create_by(advice_id: @advice.id)
      redirect_to user_path(current_user)
    else
      redirect_to new_advice_path
    end
  end

  def index
    @advice = Advice.new
    if params[:tag]
      @advices = Advice.tagged_with(params[:tag]).order('created_at DESC')
    else
      @advices = Advice.all.order('created_at DESC')
    end
  end

  def vote
    @advice = Advice.find(params[:id])
  end

  private
    def advice_params
      params.require(:advice).permit(:url, { tag_list: [] })
    end

end