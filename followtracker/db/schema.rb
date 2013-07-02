# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130702165716) do

  create_table "accounts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "link"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "employees", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "link"
    t.string   "companyname"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "filings", :force => true do |t|
    t.string   "documentType"
    t.string   "periodOfReport"
    t.string   "dateOfOriginalSubmission"
    t.string   "notSubjectToSection16"
    t.string   "issuerCik"
    t.string   "issuerName"
    t.string   "issuerTradingSymbol"
    t.string   "rptOwnerCik"
    t.string   "rptOwnerName"
    t.string   "officerTitle"
    t.string   "isDirector"
    t.string   "isOfficer"
    t.string   "isTenPercentOwner"
    t.string   "productType"
    t.string   "transactionDate"
    t.string   "transactionFormType"
    t.string   "transactionCode"
    t.string   "equitySwapInvolved"
    t.string   "transactionShares"
    t.string   "transactionPricePerShare"
    t.string   "transactionAcquiredDisposedCode"
    t.string   "sharesOwnedFollowingTransaction"
    t.string   "directOrIndirectOwnership"
    t.string   "derivsecurityTitle"
    t.string   "derivconversionOrExercisePrice"
    t.string   "derivtransactionDate"
    t.string   "derivtransactionFormTypeofficerTitle"
    t.string   "derivtransactionCode"
    t.string   "derivequitySwapInvolved"
    t.string   "derivtransactionShares"
    t.string   "derivtransactionPricePerShare"
    t.string   "derivexerciseDate"
    t.string   "derivexpirationDate"
    t.string   "derivunderlyingSecurityTitle"
    t.string   "derivunderlyingSecurityShares"
    t.string   "derivsharesOwnedFollowingTransaction"
    t.string   "derivdirectOrIndirectOwnership"
    t.string   "footnotes"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "profiles", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "link"
    t.string   "company"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "refinery_data", :force => true do |t|
    t.string   "name"
    t.string   "country"
    t.string   "city"
    t.string   "company"
    t.integer  "capacity"
    t.string   "supply"
    t.integer  "complexity"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "related_views", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "link"
    t.string   "company"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
