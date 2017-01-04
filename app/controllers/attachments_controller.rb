# encoding: utf-8
class AttachmentsController < CustomerBaseController 
  before_filter :correct_customer_user, only: [:new, :edit, :update, :create, :destroy]
  before_filter :correct_customer_user_or_admin, only: [:index]

  def index
    @attachments = @customer.attachments
  end

  def new
    @attachment = @customer.attachments.build
  end

  def edit
    @attachment = @customer.attachments.find(params[:id])
  end

  def update
    @attachment = @customer.attachments.find(params[:id])
    if @attachment.update_attributes(description: params[:attachment][:description])
      flash[:sucess] = "附件更新成功!"
      redirect_to customer_attachments_path(@customer)
    else
      render 'edit'
    end

  end

  def create
    @attachment = @customer.attachments.build
    @attachment.description = params[:attachment][:description]
    @attachment.file = params[:attachment][:file]

    if @attachment.save
      flash[:success] = "成功添加附件!"
      redirect_to customer_attachments_path(@customer)
    else
      render 'new'
    end
  end

  def destroy
    attachment = @customer.attachments.find(params[:id])
    dir_name = File.dirname(attachment.file.path)
    attachment.destroy
    Dir.delete(dir_name)
    flash[:success] = "成功删除附件!"
    redirect_to customer_attachments_path(@customer)
  end

private
  def get_customer
    Customer.find(params[:customer_id])
  end
end
