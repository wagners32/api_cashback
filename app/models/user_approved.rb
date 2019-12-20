class UserApproved < ApplicationRecord
  # validações e campos obrigatórios
  before_validation :clean_cpf, on: [:create, :update]
  validate :validar_cpf
  validates :cpf, presence: true, uniqueness: true
 
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
