class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

  validates :full_name, presence: true, length: { maximum: 50 }

  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first
    return user if user.present?

    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token(0, 20)
      user.full_name = auth.info.name
      user.provider_image = auth.info.image
      user.uid = auth.uid
      user.provider = auth.provider

      # if you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails
      user.skip_confirmation!
    end
  end
end