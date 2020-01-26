# frozen_string_literal: true

class Membership < ApplicationRecord
  include NameFormatter

  has_one_attached :csv_file

  scope :by_id, ->(id) { where(id: id) }
  scope :autocomplete, ->(term, limit = 10) { where('immutable_unaccent(name) ILIKE ?', "%#{term.split.join('%')}%").limit(limit) }

  def autocomplete_label
    "#{id} - #{name} (#{fully_qualified_organization_name})"
  end

  def name
    format_name(read_attribute(:name))
  end

  def attended_to_last_meeting?
    return false if discussion_meeting['last_attendance'].blank?

    next_month = Date.strptime(discussion_meeting['last_attendance']['date'], '%Y-%m-%d') + 1.day
    next_month.end_of_month >= Date.current
  end

  def subscribed_to_publications?
    publications_subscriptions['bsp'] || publications_subscriptions['tc'] || publications_subscriptions['rdez']
  end

  def fully_qualified_organization_name
    organizational_information['organizations'].map { |item| "#{item['level']} #{item['name']}" }.reject(&:blank?).join(' » ')
  end

  def organization(level)
    organization = organizational_information['organizations'].select { |item| level == item['level'] }.first
    organization['name']
  end

  def organizational_position
    organizational_positions.fetch('positions', {}).map { |item| item['position'] }.reject(&:blank?).join(' / ')
  end
end
