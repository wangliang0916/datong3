# encoding: utf-8
class AttachmentsController < ApplicationController

  def new
    @customer = Customer.find(params[:customer_id])
    @attachment = @customer.attachments.build
  end

  def edit
    @attachment = Attachment.find(params[:id])
  end

  def update
    @attachment = Attachment.find(params[:id])
    if @attachment.update_attributes(description: params[:attachment][:description])
      flash[:sucess] = "附件更新成功!"
      redirect_to @attachment.customer
    else
      render 'edit'
    end

  end

  def create
    @customer = Customer.find(params[:attachment][:customer_id])
    @attachment = Attachment.new
    @attachment.description = params[:attachment][:description]
    @attachment.file = params[:attachment][:file]
    @attachment.customer = @customer

    if @attachment.save
      flash[:success] = "成功添加附件!"
      redirect_to @customer
    else
      render 'new'
    end
  end

  def destroy
    @customer = Customer.find(params[:customer_id])
    attachment = @customer.attachments.find(params[:id])
    dir_name = File.dirname(attachment.file.path)
    #attachment.remove_file
    attachment.destroy
    Dir.delete(dir_name)
    flash[:success] = "成功删除附件!"
    redirect_to @customer
  end
end
