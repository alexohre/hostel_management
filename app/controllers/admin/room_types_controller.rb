class Admin::RoomTypesController < AdminController
  before_action :set_room_type, only: [:edit, :update, :destroy]

  def index
    @hostel_types = HostelType.all
    # @room_types = RoomType.all
    @room_types = RoomType.includes(:hostel_type)
    @room_type = RoomType.new
  end

  def edit
    @hostel_types = HostelType.all
    @room_types = RoomType.includes(:hostel_type)
  end

  def create
    @room_type = RoomType.new(room_type_params)

    if @room_type.save
      redirect_to admin_room_types_url, notice: 'Room type was successfully created.'
    else
      @hostel_types = HostelType.all
      render :index, status: :unprocessable_entity
    end
  end

  def update
    if @room_type.update(room_type_params)
      redirect_to @room_type, notice: 'Room type was successfully updated.'
    else
      render :edit
    end
  end


  def destroy
    @room_type.destroy
    redirect_to admin_room_types_url, notice: 'Room type was successfully destroyed.'
  end

  private

  def set_room_type
    @room_type = RoomType.find(params[:id])
  end

  def room_type_params
    params.require(:room_type).permit(:name, :price, :hostel_type_id)
  end
end
