class CommentsController < ApplicationController

    def create
        begin
            c = Comment.new(comment_params)
            c.user = current_user
            c.movie_id = params['movie_id']
            c.save!
        rescue => e
            flash[:danger] = "save failure"
        end
      
        redirect_to movie_path(params['movie_id'])
    end

    def destroy 
        m = Comment.find(params[:id]).movie
        Comment.destroy(params[:id])
        redirect_to movie_path(m)
    end

    private
    def comment_params
        params.require(:comment).permit(:comment_content)
    end

end