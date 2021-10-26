class OffersController < ApplicationController
  # line below will call #set_offer method before specified actions
  before_action :set_offer, only: %i[show edit update destroy]

  def home
  end

  def index
    @offers = Offer.all
  end

  def show
  end

  def new
    @offer = Offer.new # needed to instantiate the form_for
  end

  def create
    @offer = Offer.new(offer_params)
    @offer.save

    # no need for app/views/offers/create.html.erb
    redirect_to offer_path(@offer)
  end

  def edit
  end

  def update
    @offer.update(offer_params)

    # no need for app/views/offers/update.html.erb
    redirect_to offer_path(@offer)
  end

  def destroy
    @offer.destroy

    # no need for app/views/offers/destroy.html.erb
    redirect_to offers_path
  end

  private

  def offer_params
    params.require(:offer).permit(:description, :lat, :long, :price)
  end

  def set_offer
    @offer = Offer.find(params[:id])
  end
end
