Rails.application.routes.draw do
  get 'faq', to: 'static_pages#faq', as: 'faq'

  mount Lines::Engine, at: '/blog'
  mount Spree::Core::Engine, at: '/'

  Spree::Core::Engine.routes.draw do
    post '/', to: 'home#contact_us', as: 'contact_us'
  end
end
