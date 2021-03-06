
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  has_merit
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  acts_as_voter
  acts_as_follower
  acts_as_followable
  acts_as_taggable

  has_many :posts
  has_many :comments
  has_many :events
  has_many :messages
  has_many :conversations, foreign_key: :sender_id

  mount_uploader :avatar, AvatarUploader
  mount_uploader :cover, AvatarUploader

  geocoded_by :location

  validates_presence_of :name
  after_validation :geocode, if: :location_changed?
  before_validation :geocode, on: %i[create update]

  self.per_page = 10

  extend FriendlyId
    friendly_id :name, use: [:slugged, :finders]

  def tags_string
    self.tags.map{ |t| t.name}.join(' ')
  end

  def age
    now = Time.now.utc.to_date
    now.year - self.dob.year
  end
end
