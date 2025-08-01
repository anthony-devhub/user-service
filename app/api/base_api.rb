class BaseApi < Grape::API
  format :json
  prefix :api
  version 'v1', using: :path

  mount V1::UsersApi

  add_swagger_documentation if Rails.env.development?
end
