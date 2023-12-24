class Routes < BaseRoutes
  def self.list
    {
      products: {
        index: {
          get: {
            path: '/products',
            params: [ :query ]
          }
        },
        new: {
          get: {
            path: '/products/new'
          }
        },
        create: {
          post: {
            path: '/products'
          }
        },
        delete: {
          delete: {
            path: '/products/:id'
          }
        }
      }
    }
  end
end
