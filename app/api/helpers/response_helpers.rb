module Helpers
  module ResponseHelpers
    def present_success(data = {}, message = 'Success', status: 200)
      status(status)
      { status: 'success', message: message, data: data }
    end


    def present_error(message = 'Something went wrong', code: 500)
      error!({
        status: 'error',
        message: message
      }, code)
    end

    def present_paginated_success(collection, pagy, message = 'Success', status: 200)
      status(status)
      {
        status: 'success',
        message: message,
        data: collection,
        pagination: {
          page: pagy.page,
          items: pagy.items,
          count: pagy.count,
          pages: pagy.pages
        }
      }
    end

  end
end
