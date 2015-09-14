class PagesController < ApplicationController
  before_action :authenticate_user!

  def checkout
    @page = Page.not_checked_out.first
    current_user.checkout(@page)
    redirect_to edit_page_path(@page)
  end

  def start_review
    @page = Page.pending_review.first
    current_user.start_review(@page)
    redirect_to edit_page_path(@page)
  end

  def edit
    @page = Page.find(params[:id])
    if current_user.is_reviewer? || current_user.is_admin? || @page.transcriber == current_user

    else
      permission_denied
    end
  end

  def update
    # TODO: Handle case where reviewer do also transcription
    @page = Page.find(params[:id])
    @page.content = params[:page][:content]

    if current_user.is_reviewer?
      @page.reviewed_at = Time.now
    else
      @page.submitted_at = Time.now
    end

    @page.save
    flash[:notice] = "Merci!"
    redirect_to root_path
  end

end
