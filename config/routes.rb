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
        }
      }
    }
  end
end
