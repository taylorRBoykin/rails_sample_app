class MicropostsController < ApplicationController

  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: [:destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost Created"
      redirect_to root_url
    else
      # params[:page] = nil if params[:page].blank?
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 10)
      render 'static_pages/home'
      # user_path(user, :page => params[:page]) TODO apply this code to keep the user on same pagination
    end
  end

  def destroy
    @micropost.destroy
    redirect_to request.referrer || root_url if @micropost.nil?
  end

  private
  def micropost_params
    params.require(:micropost).permit(:content, :picture)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    flash[:success] = "Post Deleted."
    redirect_to root_url if @micropost.nil?
  end

end
