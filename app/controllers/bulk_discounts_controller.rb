class BulkDiscountsController < ApplicationController
  def index
    @discounts = BulkDiscount.all
    holidays
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end
end
