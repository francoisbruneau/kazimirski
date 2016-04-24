class PagesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_page, only: [:edit, :update]
  before_action :authorize_access, only: [:edit, :update]

  def checkout
    @page = Page.not_checked_out.first
    current_user.checkout(@page)
    redirect_to edit_page_path(@page)
  end

  def start_review
    if current_user.is_reviewer?
      @page = Page.pending_review.not_transcribed_by(current_user.id).first
      current_user.start_review(@page)
      redirect_to edit_page_path(@page)
    else
      logger.info "Unauthorized attempt by non-reviewer user #{current_user.id} to start reviewing page #{@page.id}."
      permission_denied
    end
  end

  def edit
  end

  def update
    @page.content = params[:page][:content]

    if params[:commit].present?
      if @page.reviewer_id == current_user.id
        @page.reviewed_at = Time.now
        Notifier.page_reviewed(@page).deliver_now
        flash[:notice] = "Merci! La page a été validée comme correcte."
      elsif @page.transcriber_id == current_user.id
        @page.submitted_at = Time.now
        Notifier.new_page_submitted(@page).deliver_now
        flash[:notice] = "Merci! La page a été envoyée pour relecture."
      end
    else
      flash[:notice] = "Votre brouillon a été enregistré."
    end

    @page.save
    redirect_to root_path
  end

  private

  def find_page
    @page = Page.find(params[:id])
  end

  def authorize_access
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

end
