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

  def spree_breadcrumbs(taxon, separator = '&nbsp;')
    return '' if current_page?('/') || taxon.nil?
    separator = raw(separator)
    crumbs = [content_tag(:li, content_tag(:span, link_to(content_tag(:span, Spree.t(:home), itemprop: 'name'), spree.root_path, itemprop: 'url') + separator, itemprop: 'item'), itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement')]
    if taxon
      crumbs << content_tag(:li, content_tag(:span, link_to(content_tag(:span, Spree.t(:products), itemprop: 'name'), spree.products_path, itemprop: 'url') + separator, itemprop: 'item'), itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement')
      crumbs << taxon.ancestors.collect { |ancestor| content_tag(:li, content_tag(:span, link_to(content_tag(:span, ancestor.name, itemprop: 'name'), seo_url(ancestor), itemprop: 'url') + separator, itemprop: 'item'), itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement') } unless taxon.ancestors.empty?
      crumbs << content_tag(:li, content_tag(:span, link_to(content_tag(:span, taxon.name, itemprop: 'name'), seo_url(taxon), itemprop: 'url'), itemprop: 'item'), class: 'active', itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement')
    else
      crumbs << content_tag(:li, content_tag(:span, Spree.t(:products), itemprop: 'item'), class: 'active', itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement')
    end
    crumb_list = content_tag(:ol, raw(crumbs.flatten.map(&:mb_chars).join), class: 'breadcrumb', itemscope: 'itemscope', itemtype: 'https://schema.org/BreadcrumbList')
    content_tag(:nav, crumb_list, id: 'breadcrumbs', class: 'breadcrumbs--wrapper')
  end

  def taxons_tree(root_taxon, current_taxon, max_level = 1)
    return '' if max_level < 1 || root_taxon.leaf?
    content_tag :div, class: 'list-group' do
      taxons = root_taxon.children.map do |taxon|
        css_class = current_taxon && current_taxon.self_and_ancestors.include?(taxon) ? 'list-group-item active' : 'list-group-item'
        link_to(taxon.name, seo_url(taxon), class: css_class) + taxons_tree(taxon, current_taxon, max_level - 1)
      end
      safe_join(taxons, "\n")
    end
  end
end
