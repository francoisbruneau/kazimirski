# TODO create rake task which generates all Pages from source PDFs (via archive.org)

class Page < ActiveRecord::Base
  belongs_to :submitter, class_name: "User", foreign_key: "submitter_id"
  belongs_to :reviewer, class_name: "User", foreign_key: "reviewer_id"

  scope :submitted, -> { where "submitted_at IS NOT NULL AND submitter_id IS NOT NULL"}
  scope :pending_review, -> { where "submitted_at IS NOT NULL and reviewed_at IS NULL"}
  scope :reviewed, -> { where "reviewed_at IS NOT NULL and reviewer_id IS NOT NULL"}

  has_attached_file :scanned_image
  validates_attachment_content_type :scanned_image, :content_type => /\Aimage\/.*\Z/
  validates :scanned_image, :attachment_presence => true

  validates :book_nr, :source_page_nr, numericality: true, presence: true

  # TODO: Check content is non empty when submitting

  # TODO: Validate reviewer_id differs from submitter_id

  def self.percent_validated
    self.reviewed.count*1.0 / self.count * 100.0
  end

end
