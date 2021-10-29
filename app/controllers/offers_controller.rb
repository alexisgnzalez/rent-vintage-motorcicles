class OffersController < ApplicationController
  # line below will call #set_offer method before specified actions
  skip_before_action :authenticate_user!, only: %i[home index]
  before_action :set_offer, only: %i[show edit update destroy]

  def garage
    @garage = current_user.offers
  end

  def home
  end

  def index
    # @offers = Offer.all
    if params[:query].present?
      @offers = Offer.search_by_description(params[:query])
    else
      @offers = policy_scope(Offer)
    end
  end

  def show
  end

  def new
    @offer = current_user.offers.new # needed to instantiate the form_for
    authorize @offer
  end

  def create
    @offer = current_user.offers.new(offer_params)
    authorize @offer

    if @offer.save
      # redirect_to restaurant_path(@restaurant)
      redirect_to offer_path(@offer)
    else
      render :new
    end
  end

  def edit
  end

  def update
    authorize @offer

    # no need for app/views/offers/update.html.erb
    if @offer.update(offer_params)
      redirect_to offer_path(@offer)
    else
      render :edit
    end
  end

  def destroy
    authorize @offer
    @offer.destroy
    # no need for app/views/offers/destroy.html.erb
    redirect_to offers_path
  end

  def top
    @offers = policy_scope(Offer).order(created_at: :asc).limit(5)
  end

  private

  def offer_params
    params.require(:offer).permit(:description, :lat, :long, :price, photos: [])
  end

  def set_offer
    @offer = Offer.find(params[:id])
    authorize @offer
  end
end
