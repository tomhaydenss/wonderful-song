class Membership < ApplicationRecord
  include NameFormatter

  has_one_attached :csv_file

  scope :autocomplete, ->(term, limit = 10) { where('immutable_unaccent(name) ILIKE ?', "%#{term}%").limit(limit) }

  def autocomplete_label
    "#{id} - #{name} (#{fully_qualified_organization_name})"
  end

  def name
    # format_name(self.name)
    format_name(read_attribute(:name))
  end

  def has_attended_to_last_meeting?
    return false if discussion_meeting['last_attendance'].blank?
    Date.strptime(discussion_meeting['last_attendance']['date'], '%Y-%m-%d') + 1.month > Date.current
  end

  def has_subscribed_to_publications?
    publications_subscriptions['bsp'] || publications_subscriptions['tc'] || publications_subscriptions['rdez']
  end

  def fully_qualified_organization_name
    organizational_information['organizations'].map { |item| "#{item['level']} #{item['name']}" }.reject(&:blank?).join(' » ')
  end

  def organizational_position
    organizational_positions.fetch('positions', {}).map { |item| item['position'] }.reject(&:blank?).join(' / ')
  end
end
