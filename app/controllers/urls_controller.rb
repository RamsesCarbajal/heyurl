# frozen_string_literal: true

require "browser"

class UrlsController < ApplicationController
  def index
    # recent 10 short urls
    @url ||= Url.new
    @urls = Url.all
    
    return if !@urls.empty?
    
    @urls = [
      Url.new(short_url: 'ABCDE', original_url: 'http://google.com', created_at: Time.now),
      Url.new(short_url: 'ABCDG', original_url: 'http://facebook.com', created_at: Time.now),
      Url.new(short_url: 'ABCDF', original_url: 'http://yahoo.com', created_at: Time.now)
    ]
  end

  def create
    #raise 'add some code'
    url = valid_create_params
    @urls = Url.all
    @url = Url.new(original_url: url, short_url: random_string)
    unless @url.save
      respond_to do |format|
        format.html{render :index, status: :unprocessable_entity }
      end
      return
    end

    redirect_to :controller => 'urls', :action => 'index'
    # create a new URL record
  end

  def valid_create_params
    new_params = params.require("url").permit(:original_url)
    original_url = new_params[:original_url]
    return nil if !(/\Ahttps?:\/\/[\S]+\z/.match(original_url))

    return nil if !Url.where(original_url: original_url).first.nil?
    original_url
  end

  def random_string
    (0...5).map { (65 + rand(26)).chr }.join
  end
  def browser
    @browser ||= Browser.new(
      request.headers["User-Agent"],
      accept_language: request.headers["Accept-Language"]
    )
  end

  def show
    puts browser

    puts "params"
    puts params[:url]

    @url = Url.find params[:url]


    @url = Url.new(short_url: 'ABCDE', original_url: 'http://google.com', created_at: Time.now)

    clicks = Click.where('url_id = :url_id and created_at > :after_date ', url_id: @url.id ,after_date: Date.today.beginning_of_month).order(created_at: :asc)

    @daily_clicks = []
    @browsers_clicks = []
    @platform_clicks = []
    aux_date ={}
    clicks.each do |c|
      if aux_date[("day_" + c.created_at.day.to_s).to_s].nil?
        aux_date[("day_" + c.created_at.day.to_s).to_s] = 0
      end
      aux_date[("day_" + c.created_at.day.to_s).to_s] = aux_date[("day_" + c.created_at.day.to_s).to_s] + 1
    end

    @daily_clicks = [
      ['1', 13],
      ['2', 2],
      ['3', 1],
      ['4', 7],
      ['5', 20],
      ['6', 18],
      ['7', 10],
      ['8', 20],
      ['9', 15],
      ['10', 5]
    ]
    @browsers_clicks = [
      ['IE', 13],
      ['Firefox', 22],
      ['Chrome', 17],
      ['Safari', 7]
    ]
    @platform_clicks = [
      ['Windows', 13],
      ['macOS', 22],
      ['Ubuntu', 17],
      ['Other', 7]
    ]
  end

  def visit
    # params[:short_url]
    render plain: 'redirecting to url...'
  end
end
