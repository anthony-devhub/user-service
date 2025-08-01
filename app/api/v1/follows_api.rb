module V1
  class FollowsApi < Grape::API
    resource :follows do
      desc 'List follows'
      get do
        Follow.all
      end
    end
  end
end