class CreateFilings < ActiveRecord::Migration
  def change
    create_table :filings do |t|
      t.string :documentType
      t.string :periodOfReport
      t.string :dateOfOriginalSubmission
      t.string :notSubjectToSection16
      t.string :issuerCik
      t.string :issuerName
      t.string :issuerTradingSymbol
      t.string :rptOwnerCik
      t.string :rptOwnerName
      t.string :officerTitle
      t.string :isDirector
      t.string :isOfficer
      t.string :isTenPercentOwner
      t.string :productType
      t.string :transactionDate
      t.string :transactionFormType
      t.string :transactionCode
      t.string :equitySwapInvolved
      t.string :transactionShares
      t.string :transactionPricePerShare
      t.string :transactionAcquiredDisposedCode
      t.string :sharesOwnedFollowingTransaction
      t.string :directOrIndirectOwnership
      t.string :derivsecurityTitle
      t.string :derivconversionOrExercisePrice
      t.string :derivtransactionDate
      t.string :derivtransactionFormTypeofficerTitle
      t.string :derivtransactionCode
      t.string :derivequitySwapInvolved
      t.string :derivtransactionShares
      t.string :derivtransactionPricePerShare
      t.string :derivexerciseDate
      t.string :derivexpirationDate
      t.string :derivunderlyingSecurityTitle
      t.string :derivunderlyingSecurityShares
      t.string :derivsharesOwnedFollowingTransaction
      t.string :derivdirectOrIndirectOwnership
      t.string :footnotes

      t.timestamps
    end
  end
end
