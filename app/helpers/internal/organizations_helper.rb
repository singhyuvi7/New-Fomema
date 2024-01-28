module Internal::OrganizationsHelper

  # render organization tree in UL LI format
  def render_organization_tree(nodes)
    return ''.html_safe if nodes.empty?
    content_tag(:ul) do
      nodes.map do |node|
        content_tag(:li, nil, data: { id: node.id }) do
          node.name.html_safe + render_organization_tree(node.children)
        end
      end.join.html_safe
    end
  end

end
