class List < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates_presence_of :name, :user_id
end
