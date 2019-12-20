class User < ApplicationRecord
  require 'cpf_cnpj'

  has_secure_password

  has_many :purchases

  # validações e campos obrigatórios
  before_validation :clean_cpf, on: [:create, :update]
  validate :validar_cpf
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
    self.cpf.gsub('.','').gsub('-','') if !self.cpf.nil?
  end

  def clean_cpf
     self.cpf = self.cpf.gsub('.','').gsub('-','') if !self.cpf.nil?
  end

  def validar_cpf
    if !self.cpf.nil?
      if !CPF.valid?(self.cpf, strict: true) 
        errors.add(:base, 'Informe um CPF válido')
        throw(:abort) if errors.present?
      end
    end
  end
end
