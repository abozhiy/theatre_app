class Api::V1::PerformancesController < ActionController::API

  def index
    performances = Performance.actual_list
    render json: performances, status: :ok
  end

  def create
    performance = Performance.new(performance_params)

    if performance.save
      render json: performance, status: :ok
    else
      render json: {errors: performance.errors.messages}, status: :unprocessable_entity
    end
  end

  def destroy
    @performance = Performance.find(params[:id])
    @performance.destroy
    head :ok
  end

  private

  def performance_params
    params.require(:performance).permit(:title, :start_date, :end_date)
  end
end