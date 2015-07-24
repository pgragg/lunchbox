class TrimestersController < ApplicationController


  def edit
    @year = Year.find(params[:year_id])
    @trimester = Trimester.find(params[:id])
  end

  # def create
  #   @holiday = Holiday.new(holiday_params)
  #   if @holiday.save
  #    redirect_to holidays_path, notice: "Holiday was saved successfully."
  #   else
  #    flash[:error] = "Error creating holiday. Please try again."
  #    render :new
  #  end
  # end

  def update
    @year = Year.find(params[:year_id])
    @trimester = Trimester.find(params[:id])
    if @trimester.update_attributes(trimester_params)
      redirect_to holidays_path, notice: "Trimester was updated successfully."
    else 
      flash[:error] = "Error saving trimester. Please try again."
    end 
  end

  # def destroy
  #   # @year = Year.find(params[:year_id])
  #   @holiday = Holiday.find(params[:id])
  #   if @holiday.delete
  #    redirect_to holidays_path, notice: "Holiday was deleted successfully."
  #  else
  #    flash[:error] = "Error deleting lunch. Please try again."
  #    redirect_to holidays_path
  #  end
  # end

  private 

  def trimester_params
    params.require(:trimester).permit(:start_date, :end_date, :number)
  end
end

