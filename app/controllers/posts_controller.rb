class PostsController < ApplicationController
  def index
    @tag = params[:tag]
    @page = params[:page]
    @posts = Post.find_recent(:tag => @tag, :include => :tags, :page => @page)

    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
  end

  def show
    @post = Post.find_by_permalink(*([:year, :month, :day, :slug].collect {|x| params[x] } << {:include => [:tags]}))
  end
end
