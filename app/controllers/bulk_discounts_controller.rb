class BulkDiscountsController < ApplicationController
  def index
    @discounts = BulkDiscount.all
    holidays
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    merchant.bulk_discounts.create(discount_rate: params[:discount_rate], threshold: params[:threshold])
    redirect_to "/merchants/#{merchant.id}/bulk_discounts"
  end

  def destroy

    BulkDiscount.destroy(params[:id])
    redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts"
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    altered_bulk_discount = BulkDiscount.find(params[:id])
    altered_bulk_discount.update(threshold: params[:bulk_discount][:threshold], discount_rate: params[:bulk_discount][:discount_rate])
    redirect_to "/merchants/#{altered_bulk_discount.merchant_id}/bulk_discounts/#{altered_bulk_discount.id}"
  end
end
