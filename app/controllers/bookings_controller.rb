class BookingsController < ApplicationController
  # line below will call #set_booking method before specified actions
  # before_action :set_booking, only: %i[edit update destroy]
  before_action :set_booking, only: %i[destroy]

  def booked
    @bookeds = current_user.bookings
  end

  def new
    @booking = Booking.new # needed to instantiate the form_for
    @offer = Offer.find(params[:offer_id])
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.offer = Offer.find(params[:offer_id])
    @booking.user = current_user

    if @booking.save
      # redirect_to restaurant_path(@restaurant)
      # redirect_to offer_path(@offer)
      redirect_to offers_path # Just meanwhile
    else
      render :new
      # redirect_to new_offer_booking_path(@booking.offer.id)
    end

    # no need for app/views/offers/create.html.erb
    # redirect_to booking_path(@booking)
  end

  # def edit
  # end

  # def update
  #   @booking.update(booking_params)

  #   # no need for app/views/offers/update.html.erb
  #   redirect_to booking_path(@booking)
  # end

  def destroy
    @booking.destroy

    # no need for app/views/offers/destroy.html.erb
    redirect_to offers_path # It should redirect to the list of users bookings
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end
end
