class Task < ApplicationRecord
  belongs_to :user
  belongs_to :list

  validates_presence_of :title, :user_id
end
