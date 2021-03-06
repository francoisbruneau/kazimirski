class Page < ActiveRecord::Base
  belongs_to :transcriber, class_name: "User", foreign_key: "transcriber_id"
  belongs_to :reviewer, class_name: "User", foreign_key: "reviewer_id"

  # Page lifecycle
  scope :not_checked_out, -> { where "checked_out_at IS NULL and transcriber_id IS NULL" }
  scope :submitted, -> { where "submitted_at IS NOT NULL AND transcriber_id IS NOT NULL"}
  scope :pending_review, -> { where "submitted_at IS NOT NULL AND transcriber_id IS NOT NULL and reviewed_at IS NULL"}
  scope :reviewed, -> { where "reviewed_at IS NOT NULL and reviewer_id IS NOT NULL"}
  scope :not_transcribed_by, ->(user_id) { where("transcriber_id != ?", user_id) }

  validates :book_nr, :source_page_nr, numericality: true, presence: true
  validate :reviewer_id_cannot_be_same_as_transcriber_id

  before_save :sanitize_content

  has_paper_trail

  def reviewer_id_cannot_be_same_as_transcriber_id
    if reviewer_id.present? && transcriber_id.present? && reviewer_id == transcriber_id
      errors.add(:reviewer_id, "can't be the same as transcriber_id")
    end
  end

  def self.percent_validated
    self.reviewed.count*1.0 / self.count * 100.0
  end

  def in_review?
    self.reviewer_id.present? && self.reviewed_at.nil?
  end

  def in_transcription?
    self.transcriber_id.present? && self.submitted_at.nil?
  end

  def in_review_by?(user)
    self.in_review? && self.reviewer_id == user.id
  end

  def in_transcription_by?(user)
    self.in_transcription? && self.transcriber_id == user.id
  end

  def viewer_url
    "https://archive.org/stream/dictionnairearab0#{self.book_nr}bibeuoft#page/#{self.source_page_nr}/mode/1up"
  end

  private

  def sanitize_content
    white_list_sanitizer = Rails::Html::WhiteListSanitizer.new
    allowed_tags = ['br', 'em']
    self.content = white_list_sanitizer.sanitize(self.content, { :tags => allowed_tags })
  end

end
