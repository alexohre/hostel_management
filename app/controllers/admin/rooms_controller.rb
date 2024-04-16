class Admin::RoomsController < AdminController
  before_action :set_room, only: [:edit, :show, :update]

  def index 
    @room_types = RoomType.includes(:hostel_type)
    # @rooms = Room.includes(:room_type)
    @pagy, @rooms = pagy(Room.includes(:room_type), items: 7)
    @room = Room.new
  end

  def show 
    @beds = @room.beds
  end

  def create
    room_type = RoomType.find(params[:room][:room_type_id])
    number_of_rooms = params[:room][:number_of_rooms].to_i
    starting_number = params[:room][:starting_number].to_i
    number_of_beds = params[:room][:number_of_beds].to_i
    created_rooms = []

    if number_of_rooms > 0
      number_of_rooms.times do |i|
        room_number = starting_number + i
        room = room_type.rooms.build(room_number: room_number, number_of_beds: number_of_beds, status: 'available')
        created_rooms << room

        # Create beds for the current room
        number_of_beds.times do |j|
          bed_name = "Bed #{('A'.ord + j).chr}"  # Use A-Z for bed numbering
          room.beds.build(bed_name: bed_name, reserved: false)
        end
      end
    else
      redirect_to admin_rooms_path, alert: 'Number of rooms must be greater than 0'
      return
    end

    if created_rooms.all?(&:save)
      redirect_to admin_rooms_path, notice: "Rooms created successfully"
    else
      @room = Room.new
      @room_types = RoomType.includes(:hostel_type)
      @pagy, @rooms = pagy(Room.includes(:room_type), items: 7)

      render :index, status: :unprocessable_entity
    end
  end



  def edit
     @room_types = RoomType.includes(:hostel_type)
     
    # Render the edit form with the room's current attributes
  end

  def update
    @room_types = RoomType.includes(:hostel_type)
    if @room.update(room_params)
      redirect_to admin_rooms_path, notice: 'Room was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:room_type_id, :room_number, :number_of_beds, :status)
  end
end