class FiltersController < ApplicationController
  before_action :set_filter, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:index, :new]
  after_action :verify_policy_scoped, only: :index

  # GET /filters
  # GET /filters.json
  def index
    @filters = policy_scope(Filter)
  end

  # GET /filters/1
  # GET /filters/1.json
  def show
    authorize @filter
  end

  # GET /filters/new
  def new
    @filter = Filter.new
  end

  # GET /filters/1/edit
  def edit
    authorize @filter, :update?
  end

  # FILTER /filters
  # FILTER /filters.json
  def create
    @filter = Filter.new(filter_params)
    authorize @filter
    current_user.filters << @filter

    respond_to do |format|
      if @filter.save
        format.html { redirect_to @filter, notice: 'Filter was successfully created.' }
        format.json { render action: 'show', status: :created, location: @filter }
      else
        format.html { render action: 'new' }
        format.json { render json: @filter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /filters/1
  # PATCH/PUT /filters/1.json
  def update
    authorize @filter
    respond_to do |format|
      if @filter.update(filter_params)
        format.html { redirect_to @filter, notice: 'Filter was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @filter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /filters/1
  # DELETE /filters/1.json
  def destroy
    authorize @filter
    @filter.destroy
    respond_to do |format|
      format.html { redirect_to filters_url, notice: 'Filter was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_filter
      @filter = Filter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def filter_params
      params.require(:filter).permit(*policy(@filter || Filter).permitted_attributes)
    end
end
