ActiveAdmin.register ProductStockItem do
  # Specify parameters which should be permitted for assignment
  permit_params :product_id, :stock_id, :quantity

  menu false

  # Pre-select product when product_id is passed
  controller do
    def new
      @product_stock_item = ProductStockItem.new
      return unless params[:product_id].present?

      @product_stock_item.product = Product.find(params[:product_id])
      @product_stock_item.product_id = params[:product_id]
    end
  end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :product
  filter :stock
  filter :quantity
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :product
    column :stock
    column :quantity
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :product
      row :stock
      row :quantity
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      if f.object.product_id.present?
        # Add hidden field to preserve product_id when field is disabled
        f.input :product_id, as: :hidden
        f.input :product,
                selected: f.object.product_id,
                input_html: { disabled: true }
      else
        f.input :product
      end
      f.input :stock
      f.input :quantity
    end
    f.actions
  end
end
