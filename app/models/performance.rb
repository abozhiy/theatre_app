class Performance < ApplicationRecord

  validates :title, :start_date, :end_date, presence: true
  validate :no_overlap

  scope :actual_list, -> { where('end_date >= ?', Date.current) }

  scope :overlapping, -> (dates) do
    query = <<-SQL
      (:from BETWEEN performances.start_date AND performances.end_date OR
      :to BETWEEN performances.start_date AND performances.end_date) OR 
      (:from <= performances.start_date AND :to >= performances.end_date)
    SQL
    where(query, from: dates[:from], to: dates[:to])
  end


  def no_overlap
    msg = 'The performance has already been scheduled for the specified date'
    errors.add(:start_date, msg) if Performance.overlapping({from: start_date, to: end_date}).any?
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