module PollsHelper
  # @param [Poll] entity
  def admin_poll_link(entity)
    link_to(entity.name, admin_poll_path(entity.id))
  end

  # @param [Poll] entity
  def poll_link(entity)
    link_to(entity.name, poll_path(entity.id))
  end

  # @param [Poll] entity
  def poll_image_medium(entity)
    return '' if entity.image.blank?
    versions = "#{entity.image.medium_2x.url} 2x"
    image_tag(entity.image.medium.url, alt: entity.name, srcset: versions)
  end

  # @param [Poll] entity
  def poll_image_small(entity)
    return '' if entity.image.blank?
    versions = "#{entity.image.medium.url} 2x"
    image_tag(entity.image.small.url, alt: entity.name, srcset: versions)
  end

  # @param [Poll] entity
  def poll_image_preview(entity)
    return '' if entity.image.blank?
    versions = "#{entity.image.preview_2x.url} 2x"
    image_tag(entity.image.preview.url, alt: entity.name, srcset: versions)
  end
end
