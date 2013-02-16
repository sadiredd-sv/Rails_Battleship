class GameHistoriesController < ApplicationController
  # GET /game_histories
  # GET /game_histories.json
  def index
    @game_histories = GameHistory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @game_histories }
    end
  end

  # GET /game_histories/1
  # GET /game_histories/1.json
  def show
    @game_history = GameHistory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game_history }
    end
  end

  # GET /game_histories/new
  # GET /game_histories/new.json
  def new
    @game_history = GameHistory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game_history }
    end
  end

  # GET /game_histories/1/edit
  def edit
    @game_history = GameHistory.find(params[:id])
  end

  # POST /game_histories
  # POST /game_histories.json
  def create
    @game_history = GameHistory.new(params[:game_history])

    respond_to do |format|
      if @game_history.save
        format.html { redirect_to @game_history, notice: 'Game history was successfully created.' }
        format.json { render json: @game_history, status: :created, location: @game_history }
      else
        format.html { render action: "new" }
        format.json { render json: @game_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /game_histories/1
  # PUT /game_histories/1.json
  def update
    @game_history = GameHistory.find(params[:id])

    respond_to do |format|
      if @game_history.update_attributes(params[:game_history])
        format.html { redirect_to @game_history, notice: 'Game history was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_histories/1
  # DELETE /game_histories/1.json
  def destroy
    @game_history = GameHistory.find(params[:id])
    @game_history.destroy

    respond_to do |format|
      format.html { redirect_to game_histories_url }
      format.json { head :no_content }
    end
  end
end
