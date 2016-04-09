class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  validates_strength_of :password, :with => :email, :level => :good

  belongs_to :role
  before_create :set_default_role

  has_many :submitted_pages, -> { where "submitted_at IS NOT NULL" }, class_name: "Page", foreign_key: "transcriber_id" # submitted by me
  has_many :integrated_pages, -> { where "reviewed_at IS NOT NULL" }, class_name: "Page", foreign_key: "transcriber_id" # submitted by me and reviewed by someone else
  has_many :reviewed_pages, -> { where "reviewed_at IS NOT NULL" }, class_name: "Page", foreign_key: "reviewer_id" # reviewed by me

  has_paper_trail

  after_create :send_new_sign_up_notification_mail

  def is_transcriber?
    self.role.name == 'transcriber'
  end

  def is_reviewer?
    self.role.name == 'reviewer'
  end

  def is_admin?
    self.role.name == 'admin'
  end

  def has_draft_page?
    draft_page.present?
  end

  def draft_page
    Page.where(:transcriber_id => self.id, :submitted_at => nil).first
  end

  def has_started_a_review?
    started_review_page.present?
  end

  def started_review_page
    Page.where(:reviewer_id => self.id, :reviewed_at => nil).first
  end

  def checkout(page)
    page.checked_out_at = Time.now
    page.transcriber_id = self.id
    page.save
  end

  def start_review(page)
    page.reviewer_id = self.id
    page.save
  end

  def self.transcribers
    role = Role.find_by_name('transcriber')
    self.where(:role_id => role.id)
  end

  private
  def set_default_role
    self.role ||= Role.find_by_name('transcriber')
  end

  def send_new_sign_up_notification_mail
    Notifier.new_sign_up(self.email, self.created_at).deliver_now
  end
end
