module Helpers
  module PaginationHelper
    extend Grape::API::Helpers
    include Pagy::Backend

    def paginate(collection, page:, items:)
      pagy(collection, page: page, items: items)
    end

    def pagy_metadata(pagy)
      {
        page: pagy.page,
        items: pagy.items,
        count: pagy.count,
        pages: pagy.pages,
        next: pagy.next,
        prev: pagy.prev
      }
    end

    def present_paginated_success(collection, message = 'Success', status: 200)
      pagy, records = pagy(collection)
      status(status)
      {
        status: 'success',
        message: message,
        data: records,
        pagination: pagy_metadata(pagy)
      }
    end
  end
end
