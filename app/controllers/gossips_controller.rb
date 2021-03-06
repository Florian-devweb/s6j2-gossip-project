class GossipsController < ApplicationController
  before_action :authenticate_user

  def gossip_params
    params.require(:gossip).permit(:title, :content)
  end

  def index
    @gossips = Gossip.all
    #flash.now[:notice] = "We have exactly #{@gossips.size} books available."

  end

  def show
    #@gossips = Gossip.find_by(id:params[:id])
    @gossip = Gossip.find_by(id: params[:id])
    @gossip_comments_count = @gossip.comments.all.count
    @gossip_likes_count = @gossip.likes.all.count
  end

  def new
    @gossip = Gossip.new
  end

  def create
    puts session[:user_id]
    user = User.find_by(id: session[:user_id])
    puts user.id
    @gossip = Gossip.create(title: params[:gossip_title], content: params[:gossip_content], user_id: user.id)

    if @gossip.save # essaie de sauvegarder en base @gossip
      # si ça marche, il redirige vers la page d'index du site
      # flash[:notice] = "Post successfully created"
      # gflash :success => "The product has been created successfully!"
      flash["success"] = "Gossip successfully created!"
      redirect_to gossips_path
    else
      # sinon, il render la view new (qui est celle sur laquelle on est déjà)
      flash["error"] = "Post don't created"
      render new_gossip_path
    end
  end

  def edit
    gossip = Gossip.find(params[:id])
    if gossip.user_id == session[:user_id]
      @gossip = Gossip.find(params[:id])
    else
      redirect_to gossips_path
    end
  end

  def update
    gossip = Gossip.find(params[:id])
    if gossip.user_id == session[:user_id]
      @gossip = Gossip.find(params[:id])
      if @gossip.update(gossip_params)
        redirect_to @gossip
      else
        render :edit
      end
    else
      redirect_to gossips_path
    end
  end

  def destroy
    gossip = Gossip.find(params[:id])
    if gossip.user_id == session[:user_id]
      @gossip = Gossip.find(params[:id])
      @gossip.destroy
      redirect_to gossips_path
    else
      redirect_to gossips_path
    end
  end

  private

  def authenticate_user
    unless current_user
      flash[:danger] = "Please log in."
      redirect_to new_session_path
    end
  end
end
