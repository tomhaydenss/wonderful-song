class PositionsController < ApplicationController
  before_action :set_position, only: [:show, :edit, :update, :destroy]

  # GET /positions
  # GET /positions.json
  def index
    @positions = Position.order(:precedence_order).all.paginate(page: params[:page], per_page: 15)
  end

  # GET /positions/1
  # GET /positions/1.json
  def show
  end

  # GET /positions/new
  def new
    @position = Position.new
  end

  # GET /positions/1/edit
  def edit
    @permissions = @position.permissions.map(&:identifier)
  end

  # POST /positions
  # POST /positions.json
  def create
    @position = Position.new(position_params)

    respond_to do |format|
      if @position.save
        save_permissions
        format.html { redirect_to @position, notice: 'Position was successfully created.' }
        format.json { render :show, status: :created, location: @position }
      else
        format.html { render :new }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /positions/1
  # PATCH/PUT /positions/1.json
  def update
    respond_to do |format|
      if @position.update_attributes(position_params)
        save_permissions
        format.html { redirect_to @position, notice: 'Position was successfully updated.' }
        format.json { render :show, status: :ok, location: @position }
      else
        format.html { render :edit }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /positions/1
  # DELETE /positions/1.json
  def destroy
    @position.destroy
    respond_to do |format|
      format.html { redirect_to positions_url, notice: 'Position was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def save_permissions
    # remove unwanted permissions
    if @position.permissions
      @position.permissions.reject do |permission|
        permissions_params.include? permission.identifier
      end.each { |permission| permission.delete }
    end

    # create new permissions
    permissions_params.each do |params|
      permission = params.split('_', 2)
      perm = Permission.find_or_create_by(action: permission[0], subject: permission[1], position: @position)
      byebug if perm.errors.size > 0
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_position
    @position = Position.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.

  def position_params
    params.require(:position).permit(:description, :precedence_order)
  end

  def permissions_params
    params.permit(permissions: [])[:permissions].reject(&:blank?)
  end
end
