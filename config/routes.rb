Rails.application.routes.draw do
  mount Lines::Engine, at: '/blog'
  mount Spree::Core::Engine, at: '/'
end
