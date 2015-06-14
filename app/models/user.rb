class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  belongs_to :role
  before_create :set_default_role

  has_many :submitted_pages, -> { where "submitted_at IS NOT NULL" }, class_name: "Page", foreign_key: "submitter_id" # submitted by me
  has_many :integrated_pages, -> { where "reviewed_at IS NOT NULL" }, class_name: "Page", foreign_key: "submitter_id" # submitted by me and reviewed by someone else
  has_many :reviewed_pages, -> { where "reviewed_at IS NOT NULL" }, class_name: "Page", foreign_key: "reviewer_id" # reviewed by me

  def has_draft_page?
    draft_page.present?
  end

  def draft_page
    Page.where(:submitter_id => self.id, :submitted_at => nil).first
  end

  private
  def set_default_role
    self.role ||= Role.find_by_name('transcriber')
  end
end
