class BaseApi < Grape::API
  format :json
  prefix :api
  version 'v1', using: :path

  mount V1::UsersApi

  if Rails.env.development?
    add_swagger_documentation(
      api_version: 'v1',
      hide_documentation_path: true,
      mount_path: '/swagger',
      hide_format: true,
      info: {
        title: 'Test Prep API',
        description: 'API documentation for the Test Prep'
      }
    )
  end
end
