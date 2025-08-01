module V1
  class UsersApi < Grape::API
    helpers GlobalHelpers
    resource :users do
      desc 'List users'
      params do
        optional :page, type: Integer, default: 1
        optional :limit, type: Integer, default: 20
      end
      get do
        users = User.order(created_at: :desc) # or whatever your scope
        pagy, records = paginate(users, page: params[:page].to_i, limit: params[:limit].to_i)
        present_paginated_success(records.to_a, pagy, "Successfully fetched users!")
      end

      desc 'Create a user'
      params do
        requires :name, type: String, desc: 'User name'
      end
      post do
        user = User.create!(declared(params))
        present_success(user, "New user has been created!")
      end

      desc 'Return a specific user'
      params do
        requires :id, type: String, desc: 'User ID'
      end
      route_param :id do
        get do
          user = User.find(params[:id])
          if user.present?
            present_success(user)
          else
            present_error("User not found", 404)
          end
        end
      end

      desc 'Update a user'
      params do
        requires :id, type: String, desc: 'User ID'
        optional :name, type: String, desc: 'User name'
      end
      put ':id' do
        user = User.find(params[:id])
        if user.present?
          user.update!(declared(params, include_missing: false).except(:id))
          present_success(user, "User has been updated!")
        else
          present_error("User not found", 404)
        end
      end

      desc 'Delete a user'
      params do
        requires :id, type: String, desc: 'User ID'
      end
      delete ':id' do
        user = User.find(params[:id])
        if user.present?
          user.soft_delete!
          present_success(user, "User has been deleted!")
        else
          present_error("User not found", 404)
        end
      end
    end
  end
end