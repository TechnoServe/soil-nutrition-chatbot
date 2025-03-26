class User < ApplicationRecord
  has_paper_trail

  extend Devise::Models
  include Auth::User
  include CmAdmin::User

  attr_accessor :skip_password_validation

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         :passwordless_authenticatable

  before_validation :skip_password, on: :create

  belongs_to :cm_role
  has_many :otp_requests, dependent: :destroy
  has_many :api_tokens, dependent: :destroy

  has_many :soil_evaluation_requests, foreign_key: :creator_id

  delegate :name, to: :cm_role, prefix: true, allow_nil: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def send_user_invite
    User::InviteToPortalJob.perform_later(id)
  end

  def can_access_admin_panel?
    true
  end

  protected

  def skip_password
    self.skip_password_validation = true
  end

  def password_required?
    return false if skip_password_validation

    super
  end
end
