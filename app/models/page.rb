# TODO create rake task which generates all Pages from source PDFs (via archive.org)

class Page < ActiveRecord::Base
  belongs_to :transcriber, class_name: "User", foreign_key: "transcriber_id"
  belongs_to :reviewer, class_name: "User", foreign_key: "reviewer_id"

  # Page lifecycle
  scope :not_checked_out, -> { where "checked_out_at IS NULL and transcriber_id IS NULL" }
  scope :submitted, -> { where "submitted_at IS NOT NULL AND transcriber_id IS NOT NULL"}
  scope :pending_review, -> { where "submitted_at IS NOT NULL AND transcriber_id IS NOT NULL and reviewed_at IS NULL"}
  scope :reviewed, -> { where "reviewed_at IS NOT NULL and reviewer_id IS NOT NULL"}

  validates :book_nr, :source_page_nr, numericality: true, presence: true

  has_paper_trail

  # TODO: Validate reviewer_id differs from transcriber_id

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

end
