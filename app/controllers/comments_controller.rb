class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def index
    @comments = Comment.all
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        post_comment(@comment)
        format.html { redirect_to @comment.article, notice: 'Comment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @comment }
      else
        format.html { render action: 'new' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def post_comment(comment)
    require 'net/http'
    req = Net::HTTP::Post.new('/', initheader = {'Content-Type' => 'application/json'})
    req.body = comment.to_json(only: [ :id, :name, :content, :article_id ],
                               methods: :pretty_date)
    response = Net::HTTP.new('0.0.0.0', '3001').start {|http| http.request(req) }
    return
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:article_id, :name, :content)
    end
end
