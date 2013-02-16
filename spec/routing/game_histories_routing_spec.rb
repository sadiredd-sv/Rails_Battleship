require "spec_helper"

describe GameHistoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/game_histories").should route_to("game_histories#index")
    end

    it "routes to #new" do
      get("/game_histories/new").should route_to("game_histories#new")
    end

    it "routes to #show" do
      get("/game_histories/1").should route_to("game_histories#show", :id => "1")
    end

    it "routes to #edit" do
      get("/game_histories/1/edit").should route_to("game_histories#edit", :id => "1")
    end

    it "routes to #create" do
      post("/game_histories").should route_to("game_histories#create")
    end

    it "routes to #update" do
      put("/game_histories/1").should route_to("game_histories#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/game_histories/1").should route_to("game_histories#destroy", :id => "1")
    end

  end
end
