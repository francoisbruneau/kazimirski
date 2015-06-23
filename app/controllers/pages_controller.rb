class PagesController < ApplicationController
  before_action :authenticate_user!

  def checkout
    @page = Page.not_checked_out.first
    current_user.checkout(@page)
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
    @page = Page.find(params[:id])
    @page.content = params[:page][:content]
    @page.submitted_at = Time.now
    @page.save
    flash[:notice] = "Merci!"
    redirect_to root_path
  end

end
