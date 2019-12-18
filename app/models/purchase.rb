class Purchase < ApplicationRecord
  belongs_to :user

  before_validation :set_value, on: [:create]
  before_validation :set_status, on: [:create, :update]
  
  attr_accessor :cpf, :original_value

  # status da compra
  enum status: [ :in_validation, :approved ]

  # validações e campos obrigatórios
  validates :cpf, presence: true
  validates :code, presence: true
  validates :value, presence: true, numericality: { greater_than: 0, less_than: 1000000 }
  validates :purchase_date, presence: true
  validate :allow_update, on: :update
  validate :check_cpf_owner?, on: :create
  
  # valida status antes da exclusão
  before_destroy do
    cannot_delete_approved
    throw(:abort) if errors.present?
  end
  
  # define status da compra antes da inclusão
  def set_status
    if !self.cpf.blank? 
      if self.cpf == '153.509.460-56' || self.cpf.gsub('.','').gsub('-','') == '15350946056'
        self.status = 'approved'
      else
        self.status = 'in_validation'
      end
    end
  end

  # valida se status permite alteração da compra
  def allow_update
    if self.status != 0
      errors.add(:status, :not_valid, message: "atual da compra não permite alteração")
    end
  end
  
  # CPF somente números
  def raw_cpf
    self.cpf.gsub('.','').gsub('-','')
  end

  def set_value
    self.value = self.original_value.to_s.gsub(',','.') if !self.value.nil?
  end

  def status_desc
    Purchase.human_enum_name(:status, self.status)
  end

  def value_formated
    ActionController::Base.helpers.number_to_currency(self.value, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end
  
  def as_json options={}
    {
      codigo: code,
      valor: value_formated, 
      data: purchase_date,
      cash_back_percent: cashback_percentual,
      cash_back_value: cashback,
      status: self.status_desc
    }
  end
 
  private
    def cannot_delete_approved
      errors.add(:base, 'Status da compra não permite exclusão') if self.status != 0
    end

    # valida se o usuário é o dono do CPF da compra
    def check_cpf_owner?
      if self.raw_cpf != self.user.raw_cpf
        # CPF da compra diferente do CPF do usuário logado
        errors.add(:base, 'CPF inválido. CPF não corresponde ao revendedor logado')
      end
      if errors.present?
        false
      else
        true
      end
    end

    
end
