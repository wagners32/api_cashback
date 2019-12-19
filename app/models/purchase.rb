class Purchase < ApplicationRecord
  # relacionamento com o Revendedor
  belongs_to :user

  # virtual fields
  attr_accessor :cpf, :original_value

  # emun status da compra
  enum status: [ :in_validation, :approved ]

  # validações e campos obrigatórios
  before_validation :set_value, on: [:create, :update]
  before_validation :set_status, on: [:create, :update]
  before_save :calc_cashback, on: [:create, :update]

  validates :cpf, presence: true
  validates :purchase_date, presence: true
  validates :code, presence: true
  validates :value, presence: true, numericality: { greater_than: 0, less_than: 1000000 }
  validate :check_cpf_owner?, on: :create
  validate :allow_update, on: :update
  
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
    #if self.status != 0
    #  errors.add(:status, :not_valid, message: "atual da compra não permite alteração")
    #end
  end
  
  # CPF somente números
  def raw_cpf
    self.cpf.gsub('.','').gsub('-','')
  end

  # tratamento para atribuição do valor da compra
  def set_value
    self.value = self.original_value.to_s.gsub(',','.') if !self.value.nil?
  end

  # status em portugês
  def status_desc
    Purchase.human_enum_name(:status, self.status)
  end

  # formatação do valor
  def value_formated
    ActionController::Base.helpers.number_to_currency(self.value, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end

  # formatação do cashback
  def cashback_formated
    ActionController::Base.helpers.number_to_currency(self.cashback, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end
  
  # metodo para formatação da consulta de compras
  def as_json options={}
    {
      id: id,
      codigo: code,
      valor: value_formated, 
      data: purchase_date.strftime("%d/%m/%Y"),
      cash_back_percent: cashback_percentual.to_s,
      cash_back_value: cashback_formated,
      status: self.status_desc
    }
  end

  # calcula cashback da compra
  def calc_cashback
    @percent = CashBackRange.where('? between min_value and max_value', self.value).first
    if @percent.nil?
      errors.add(:base, 'A tabela com as faixas de cashback não foi inicializada')
      throw(:abort) if errors.present?
    else
      self.cashback_percentual = @percent.percentage
      self.cashback = ((self.value.to_f/100)*@percent.percentage).round(2)
    end
  end

  private

    # status aprovado não permite exclusão
    def cannot_delete_approved
      puts "status da compra #{self.status}"
      errors.add(:base, 'Status da compra não permite exclusão') if self.status != 'in_validation'
    end

    # valida se o CPF da compra é o mesmo do usuário
    def check_cpf_owner?
      if self.raw_cpf != self.user.raw_cpf
        errors.add(:base, 'CPF inválido. CPF não corresponde ao revendedor logado')
      end
      if errors.present?
        false
      else
        true
      end
    end
end
