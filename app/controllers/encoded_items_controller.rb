class EncodedItemsController < ApplicationController
  before_action :enforce_main_encoded_item_existence, except: %i[ new create ]
  before_action :set_encoded_item, only: %i[ show destroy ]

  # GET /encoded_items or /encoded_items.json
  def index
    @encoded_items = EncodedItem.all
  end

  # GET /encoded_items/1 or /encoded_items/1.json
  def show
  end

  # GET /encoded_items/new
  def new
    @does_main_item_exist = EncodedItem.does_item_with_main_descriptor_exist?
    @encoded_item = EncodedItem.new
    @encoded_item.descriptor = EncodedItem::MAIN_DESCRIPTOR unless @does_main_item_exist
  end

  # POST /encoded_items or /encoded_items.json
  def create
    @encoded_item = EncodedItem.new(encoded_item_params)

    # TODO: Determing if we should do anything extra on create for enforcing the main item.

    respond_to do |format|
      if @encoded_item.save
        format.html { redirect_to @encoded_item, notice: "Encoded item was successfully created." }
        format.json { render :show, status: :created, location: @encoded_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @encoded_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /encoded_items/1 or /encoded_items/1.json
  def destroy
    @encoded_item.destroy!

    respond_to do |format|
      format.html { redirect_to encoded_items_path, status: :see_other, notice: "Encoded item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_encoded_item
      @encoded_item = EncodedItem.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def encoded_item_params
      params.expect(encoded_item: [ :descriptor, :value ])
    end
end
