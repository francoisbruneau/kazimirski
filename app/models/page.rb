# TODO create rake task which generates all Pages from source PDFs (via archive.org)

class Page < ActiveRecord::Base
  belongs_to :transcriber, class_name: "User", foreign_key: "transcriber_id"
  belongs_to :reviewer, class_name: "User", foreign_key: "reviewer_id"

  # Page lifecycle
  scope :not_checked_out, -> { where "checked_out_at IS NULL and transcriber_id IS NULL" }
  scope :submitted, -> { where "submitted_at IS NOT NULL AND transcriber_id IS NOT NULL"}
  scope :pending_review, -> { where "submitted_at IS NOT NULL AND transcriber_id IS NOT NULL and reviewed_at IS NULL"}
  scope :reviewed, -> { where "reviewed_at IS NOT NULL and reviewer_id IS NOT NULL"}

  has_attached_file :scanned_image,
                    :url => "/scans/:basename.:extension"
  validates_attachment_content_type :scanned_image, :content_type => /\Aimage\/.*\Z/
  validates :scanned_image, :attachment_presence => true

  validates :book_nr, :source_page_nr, numericality: true, presence: true

  # TODO: Check content is non empty when submitting

  # TODO: Validate reviewer_id differs from transcriber_id

  def self.percent_validated
    self.reviewed.count*1.0 / self.count * 100.0
  end

end
