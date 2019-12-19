class User < ApplicationRecord
  has_secure_password

  has_many :purchases

  validates :name, presence: true, length: { minimum: 3 }
  validates :username, presence: true, uniqueness: true
  validates :cpf, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }

  # CPF somente números
  def raw_cpf
    self.cpf.gsub('.','').gsub('-','')
  end
end
