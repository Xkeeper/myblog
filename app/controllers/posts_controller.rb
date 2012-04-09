class PostsController < ApplicationController
  def index
    @tag = params[:tag]
    @page = params[:page]
    @posts = Post.find_recent(:tag => @tag, :include => :tags, :page => @page)
    @tags = Post.tag_counts_on(:tags)

    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
  end

  def show
    @tags = Post.tag_counts_on(:tags)
    @post = Post.find_by_permalink(*([:year, :month, :day, :slug].collect {|x| params[x] } << {:include => [:tags]}))
  end
end
