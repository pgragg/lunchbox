class HolidaysController < ApplicationController
  def index
    @holidays = Holiday.all 
    @year = Year.last 
  end

  def new
    @holiday = Holiday.new 
  end

  def show
    @holiday = Holiday.find(params[:id])
  end

  def edit
    @holiday = Holiday.find(params[:id])
  end

  def create
    @holiday = Holiday.new(holiday_params)
    if @holiday.save
     redirect_to holidays_path, notice: "Holiday was saved successfully."
    else
     flash[:error] = "Error creating holiday. Please try again."
     render :new
   end
  end

  def update
    # @year = Year.find(params[:year_id])
    @holiday = Holiday.find(params[:id])
    if @holiday.update_attributes(holiday_params)
      redirect_to holidays_path, notice: "Holiday was updated successfully."
    else 
      flash[:error] = "Error saving holiday. Please try again."
    end 
  end

  def destroy
    # @year = Year.find(params[:year_id])
    @holiday = Holiday.find(params[:id])
    if @holiday.delete
     redirect_to holidays_path, notice: "Holiday was deleted successfully."
   else
     flash[:error] = "Error deleting lunch. Please try again."
     redirect_to holidays_path
   end
  end

  private 

  def holiday_params
    params.require(:holiday).permit(:start_date, :end_date, :name)
  end
end
