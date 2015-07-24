class YearsController < ApplicationController

  def edit
    @year = Year.find(params[:id])
  end

  def update
    @year = Year.find(params[:id])
    if @year.update_attributes(year_params)
      redirect_to holidays_path, notice: "Year was updated successfully."
    else 
      flash[:error] = "Error saving year. Please try again."
    end 
  end

  private 

  def year_params
    params.require(:year).permit(:start_date, :end_date, :name)
  end
end

