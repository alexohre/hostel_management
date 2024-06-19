class Account::AccommondationsController < AccountController
  before_action :check_profile_completion
  before_action :set_current_accommondations, only: [:new, :index]
  before_action :set_hostel_type_and_room_types, only: [:new, :create]

  def index 
   @title = "My Hostel Space"
   @accommondations = current_account.accommondations
  end
  
  def new 
    if @has_active_accommondation
      redirect_to account_accommondations_path, alert: "You already have an active accommondation."
    else
      @title = "Reserve a Space"
      @hostel_type = HostelType.where(name: current_account.gender)
      @accommondation = Accommondation.new
    end
  end

  def create 
    room_type = RoomType.find(params[:accommondation][:room_type_id])

    available_room, available_bed = find_available_bed_and_room(room_type)
    if available_room && available_bed
      @accommondation = current_account.accommondations.new(
        ref_no: generate_ref_no,
        room_no: available_room.room_number,
        bed: available_bed.bed_name,
        amount: room_type.price,
        active: true,
        hostel: @hostel_type_name,
        room_type: room_type.name,
        session: "2024/2025",
        room_type_id: room_type.id
      )

      if @accommondation.save
        # Mark the bed as reserved
        available_bed.update(reserved: true)
        redirect_to account_accommondations_path, notice: 'Accommodation reserved successfully.'
      else
        render :index, status: :unprocessable_entity
      end
    else
      redirect_to new_account_accommondation_path, alert: 'No available bed found.'
    end
  end

  def print
    @accommondation = current_account.accommondations.find(params[:id])
    pdf = AccommondationPdfService.new(@accommondation).generate

    send_data pdf, filename: "Accommondation_Invoice_#{@accommondation.ref_no}.pdf",
                   type: 'application/pdf',
                   disposition: 'attachment' # or 'attachment' for download
    # file_name = "Accommondation_Invoice_#{@accommondation.ref_no}.pdf"
    # file_path = Rails.root.join('public', 'downloads', file_name)
    # File.open(file_path, 'wb') { |file| file.write(pdf) }

    # redirect_to "/downloads/#{file_name}"
  end

  private

  def check_profile_completion
    if current_account && (current_account.first_name.blank? || current_account.last_name.blank? || current_account.address.blank? || current_account.state.blank? || current_account.country.blank? || current_account.gender.blank?)
      redirect_to edit_account_registration_path, alert: "Please complete your profile information."
    end
  end

  def set_current_accommondations
    @has_active_accommondation = current_account.accommondations.exists?(active: true)
  end

  def set_hostel_type_and_room_types
    gender_based_hostel = HostelType.find_by(name: "#{current_account.gender.capitalize} Hostel")
    @hostel_type_name = gender_based_hostel&.name || "No hostel available"
    @room_types = gender_based_hostel ? gender_based_hostel.room_types : []
  end

  def find_available_bed_and_room(room_type)
    # Rails.logger.debug "Finding available room and bed for Room Type: #{room_type.name}"
    available_room = room_type.rooms.find do |room|
      # Rails.logger.debug "Checking Room: #{room.room_number}"
      room.beds.where(reserved: false).exists?
    end

    if available_room
      available_bed = available_room.beds.find_by(reserved: false)
      # Rails.logger.debug "Available Bed: #{available_bed.inspect} in Room: #{available_room.room_number}"
    else
      # Rails.logger.debug "No Available Room found for Room Type: #{room_type.name}"
    end

    [available_room, available_bed]
  end


  def accommodation_params
    params.require(:accommodation).permit(:room_type_id,)
  end

  def generate_ref_no
    "ACCOM#{SecureRandom.hex(4).upcase}"
  end
end