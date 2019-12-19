module PurchasesHelper
  def get_cashback_total(cpf)
    HTTParty.get("https://mdaqk8ek5j.execute-api.us-east-1.amazonaws.com/v1/cashback?cpf=#{cpf}",
      {
        headers: {token: 'ZXPURQOARHiMc6Y0flhRC1LVlZQVFRnm'},
        debug_output: STDOUT,
      })
  end
end
