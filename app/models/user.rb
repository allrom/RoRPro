class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  def author?(app_object)
    id ==  app_object.user_id
  end
end