json.extract! order, :id, :address, :city, :state, :created_at, :updated_at
json.url grouped_order_url(grouped_order, format: :json)
