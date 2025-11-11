class Group < ApplicationRecord
  belongs_to :host, class_name: 'User'
  has_many :group_members, dependent: :destroy
  has_many :users, through: :group_members
  has_many :candidate_spots, dependent: :destroy
  has_many :invitations, dependent: :destroy
end
