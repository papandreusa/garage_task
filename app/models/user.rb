class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable, :registerable,
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

	has_many :projects, foreign_key: :author_id, dependent: :restrict_with_error

end
