class RoomsController < ApplicationController
    # Loads:
    # @rooms = all rooms
    # @room = current room when applicable
    before_action :load_entities
    before_action :authorise, only: [:edit, :update, :destroy]
    def index
        @rooms = Room.all
    end

    def new
        @room = Room.new
    end

    def create
        @room = Room.new permitted_parameters

        if @room.save
            flash[:success] = "Room #{@room.name} was created successfully!"
            redirect_to rooms_path
        else
            render :new
        end
    end

    def edit
    end

    def update
        if @room.update_attributes(permitted_parameters)
            flash[:success] = "Room #{@room.name} was created successfully!"
            redirect_to rooms_path
        else
            render :new
        end
    end

    def show
        @room_message = RoomMessage.new room: @room
        @room_messages = @room.room_messages.includes(:user)
    end

    def destroy
        @room.destroy
        respond_to do |format|
            format.html {redirect_to root_path, notice: "Room was successfully deleted"}
        end
    end

    protected

    def load_entities
        @rooms = Room.all
        @room = Room.find(params[:id]) if params[:id]
    end

    def authorise
        if current_user != @room.user
            flash[:alert] = "You aren't authorised to do that"
            redirect_to root_path
        end
    end

    def permitted_parameters
        params.require(:room).permit(:name)
    end
end
