class MatchesController < ApplicationController
  def invalidate_match
    match = Match.find(params[:id]) 
    match.invalidate 
    match.validate if params[:valid]
    redirect_to :back
  end 
end
