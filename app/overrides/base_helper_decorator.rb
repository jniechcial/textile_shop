Spree::FrontendHelper.module_eval do

  def link_to_cart(text = nil)
    css_class = nil

    if simple_current_order.nil? || simple_current_order.item_count.zero?
      text = "<div class='cart-icon-wrapper'><div class='cart-icon'><i class='fas fa-shopping-bag'></i></div><div class='cart-items-count'>0</div></div>"
      css_class = 'empty'
    else
      text = "<div class='cart-icon-wrapper'><div class='cart-icon'><i class='fas fa-shopping-bag'></i></div><div class='cart-items-count'><span>#{simple_current_order.item_count}</div></div>"
      css_class = 'full'
    end

    link_to text.html_safe, spree.cart_path, class: "cart-info #{css_class}"
  end

end
