class Performance < ApplicationRecord

  validates :title, :start_date, :end_date, presence: true
  validate :no_overlap

  scope :actual_list, -> { where('end_date >= ?', Date.current) }
  scope :overlapping, -> (date) { where(':date BETWEEN start_date AND end_date', date: date) }


  def no_overlap
    msg = 'The performance has already been scheduled for the specified date'
    errors.add(:start_date, msg) if Performance.overlapping(start_date).any?
    errors.add(:end_date, msg) if Performance.overlapping(end_date).any?
  end

  def serializable_hash(_options = {})
    {
        id:               id,
        title:            title,
        start_date:       start_date.strftime("%d.%m.%Y"),
        end_date:         end_date.strftime("%d.%m.%Y")
    }
  end
end