class CommentController < ApplicationController
  before_action :authenticate_user

  def new
    @comment = Comment.new
    # Méthode qui crée un potin vide et l'envoie à une view qui affiche le formulaire pour 'le remplir' (new.html.erb)
  end

  def index

    # Méthode qui récupère tous les potins et les envoie à la view index (index.html.erb) pour affichage
  end

  def show
    @comment = Comment.new
    @gossip = Gossip.find(params[:id])
    @gossip_likes_count = @gossip.likes.all.count
    @gossip_comments_count = @gossip.comments.all.count
    @gossip_comments = @gossip.comments.all
    # Méthode qui récupère le potin concerné et l'envoie à la view show (show.html.erb) pour affichage
  end

  def create
    @gossip = Gossip.find(params[:gossip_id])
    @comment = @gossip.comments.new(content: params[:content])
    @comment.user_id = session[:user_id]
    @comment.gossip_id = @gossip.id
    if @comment.save
      redirect_to "/gossips/#{@gossip.id}/comment/#{@gossip.id}/"
    else
      flash.now[:error] = "Not comented Gossip"
      render ("new")
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    @gossip = Gossip.find(params[:gossip_id])

    if comment.user_id == session[:user_id]
      @comment = Comment.find(params[:id])
      if @gossip.comments.delete(params[:id])
        redirect_to gossip_path(@gossip.id)
      end
    else
      redirect_to "/gossips/#{comment.gossip.id}"
    end
  end

  # Méthode qui créé un potin à partir du contenu du formulaire de new.html.erb, soumis par l'utilisateur
  # pour info, le contenu de ce formulaire sera accessible dans le hash params (ton meilleur pote)
  # Une fois la création faite, on redirige généralement vers la méthode show (pour afficher le potin créé)

  def edit
    puts "EDIT"
    puts "#" * 500
    comment = Comment.find(params[:id])

    if comment.user_id == session[:user_id]
      @comment = Comment.find(params[:id])
    else
      redirect_to "/gossips/#{comment.gossip.id}"
    end

    # Méthode qui récupère le potin concerné et l'envoie à la view edit (edit.html.erb) pour affichage dans un formulaire d'édition
  end

  def update
    comment = Comment.find(params[:id])
    puts "UPDATE1"
    puts "#" * 500
    if comment.user_id == session[:user_id]
      puts "UPDATE2"
      puts "#" * 500
      @comment = Comment.find(params[:id])
      if @comment.update(content: params[:content])
        redirect_to "/gossips/#{@comment.gossip.id}"
      else
        render "edit"
      end
    else
      redirect_to "/gossips/#{comment.gossip.id}"
    end
  end

  # Méthode qui met à jour le potin à partir du contenu du formulaire de edit.html.erb, soumis par l'utilisateur
  # pour info, le contenu de ce formulaire sera accessible dans le hash params
  # Une fois la modification faite, on redirige généralement vers la méthode show (pour afficher le potin modifié)

end
