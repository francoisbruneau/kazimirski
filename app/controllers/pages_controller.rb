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
    if @page.in_transcription_by?(current_user)
      logger.info "User #{current_user.id} transcribing page #{@page.id}..."
    elsif current_user.is_reviewer? && @page.in_review_by?(current_user)
      logger.info "User #{current_user.id} reviewing page #{@page.id}..."
    elsif current_user.is_admin?
      logger.info "Admin #{current_user.id} editing page #{@page.id}..."
    else
      logger.info "Unauthorized attempt by user #{current_user.id} to edit page #{@page.id}."
      permission_denied
    end
  end

  def update
    @page = Page.find(params[:id])
    @page.content = params[:page][:content]

    if params[:commit].present?
      if @page.reviewer_id == current_user.id
        @page.reviewed_at = Time.now
        flash[:notice] = "Merci! La page a été validée comme correcte."
      elsif @page.transcriber_id == current_user.id
        @page.submitted_at = Time.now
        flash[:notice] = "Merci! La page a été envoyée pour relecture."
      end
    else
      flash[:notice] = "Ton brouillon a été enregistré."
    end

    @page.save
    redirect_to root_path
  end

end
