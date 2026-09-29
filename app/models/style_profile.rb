class StyleProfile < ApplicationRecord
  belongs_to :user

  UNDERTONES = %w[warm cool neutral].freeze
  CONTRASTS = %w[high soft].freeze
  EYE_COLORS = %w[brown hazel green blue gray amber].freeze
  HAIR_COLORS = [ "black", "dark brown", "brown", "light brown", "blonde", "red", "gray or white" ].freeze

  validates :undertone, inclusion: { in: UNDERTONES }
  validates :contrast, inclusion: { in: CONTRASTS }

  def palette
    StylePalette.for(self)
  end
end
