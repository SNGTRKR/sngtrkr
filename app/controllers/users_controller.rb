class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  before_filter :self_only, :except => [:show, :timeline, :self, :new, :create]
  before_filter :authenticate_user!, :except => [:new]
  load_and_authorize_resource :except => [:new]
  cache_sweeper :user_sweeper

  def timeline
    @p_param = params[:page]
    @user = current_user
    @artists = @user.suggested_artists.first(18)
    params[:page] ||= 0
    @timeline = Timeline.user(@user.id, @p_param)
    @following = @user.followed_artists.where('image_file_name IS NOT NULL').limit(1)
    respond_to do |format|
      format.js { render :partial => 'timeline/user_timeline', :format => [:js] }
      format.html
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    # Check if this is your page
    if current_user.id == params[:id].to_i
      @user = current_user
      @following = @user.followed_artists.ordered.page(params[:page])
      @following_pages = @following.num_pages
      respond_to do |format|
        format.js { render :partial => 'users/new_following', :format => [:js] }
        format.html { render '/users/self' }
      end

    else

      @friend = User.find(params[:id])
      @following = @friend.followed_artists.ordered.page(params[:page])
      # Do we want to stop users viewing other users if they aren't facebook friends?
      #      if !current_user.friends_with? @friend, session["friend_ids"]
      #        return redirect_to :root, :error => "You do not have permissions to view this user"
      #      end
      respond_to do |format|
        format.js { render :partial => 'users/friend_artist', :format => [:js] }
        format.html # show.html.erb
      end
    end
  end

  def self
    redirect_to "/users/#{current_user.id}"
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_path, :notice => 'Account successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
