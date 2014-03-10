class FiltersController < ApplicationController
  require 'json'
  before_action :set_filter, only: [:show, :edit, :update, :destroy, :publish]
  before_action :set_user, only: :public
  after_action :verify_authorized, except: [:index, :new, :public, :show]
  after_action :verify_policy_scoped, only: :index
  rescue_from Pundit::NotAuthorizedError, with: :authenticate_user

  # GET /filters
  # GET /filters.json
  def index
    # if there is a new filter in session, save it to their account
    unless(session[:preauth_filter].nil?)
      @filter = Filter.new(JSON.parse(session.delete(:preauth_filter)))
      return save_record @filter
    end
    @filters = policy_scope(Filter)
  end

  # GET /f/:username
  # GET /f/:username.json
  def public
    @filters = policy_scope(@user.filters)
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

  # FILTER /filters
  # FILTER /filters.json
  def create
    @filter = Filter.new(filter_params)
    # If the user is not logged in, save this filter to a session and send them to get authenticated
    save_record @filter
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

  def publish
    authorize @filter
    if @filter.published?
      @filter.published = false
    else
      @filter.published = true
    end

    respond_to do |format|
      if @filter.save
        format.html { redirect_to current_user_path, notice: @filter.published? ? 'Filter is now public.' : 'Filter is now private.' }
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
      format.html { redirect_to current_user_path, notice: 'Filter was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_filter
      @filter = Filter.find(params[:id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by username: params[:username] || not_found
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def filter_params
      params.require(:filter).permit(*policy(@filter || Filter).permitted_attributes)
    end

    # Saves a filter to the current user's record
    def save_record (filter)
      # if the user is not logged in, save the filter to the session
      unless(user_signed_in?)
        session[:preauth_filter] = filter.to_json
      end
      # if they fail here they'll get sent along to the login form
      authorize filter, :create?
      current_user.filters << filter

      respond_to do |format|
        if filter.save
          format.html { redirect_to filter, notice: 'Filter was successfully created.' }
          format.json { render action: 'show', status: :created, location: filter }
        else
          format.html { render action: 'new' }
          format.json { render json: filter.errors, status: :unprocessable_entity }
        end
      end
    end

    def authenticate_user
      authenticate_user!
    end
end
