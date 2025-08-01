module V1
  class UsersApi < Grape::API
    helpers GlobalHelpers
    resource :users do
      desc 'List users'
      params do
        optional :page, type: Integer, default: 1
        optional :items, type: Integer, default: 20
      end
      get do
        users = User.order(created_at: :desc) # or whatever your scope
        pagy, records = paginate(users, page: params[:page], items: params[:items])
        present_paginated_success(records, pagy, "Successfully fetched users!")
      end
    end
  end
end