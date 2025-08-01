class User < ApplicationRecord
  include SoftDeletable

  scope :filter_by_name, ->(name) { where("name ILIKE ?", "%#{sanitize_sql_like(name)}%") if name.present? }

  def self.filtered(params)
    filter_by_name(params[:name])
  end
end
