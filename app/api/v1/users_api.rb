module V1
  class UsersApi < Grape::API
    resource :users do
      desc 'List users'
      get do
        User.all
      end
    end
  end
end