# frozen_string_literal: true

class Url < ApplicationRecord
  # scope :latest, -> {}
  validates :short_url, presence: true, format: { with: /\A[A-Z]{5}\z/,
                                                 message: "only allows letters" }

  validates :original_url, presence: true, format: { with: /\Ahttps?:\/\/[\S]+\z/,
                                                    message: "needs url format" }
end
