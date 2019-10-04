class Membership < ApplicationRecord
  has_one_attached :csv_file

  def has_attended_to_last_meeting?
    return false if discussion_meeting['last_attendance'].blank?
    Date.strptime(discussion_meeting['last_attendance']['date'], '%Y-%m-%d') + 1.month > Date.current
  end

  def has_subscribed_to_pulications?
    publications_subscriptions['bsp'] || publications_subscriptions['tc'] || publications_subscriptions['rdez']
  end

  def fully_qualified_organization_name
    organizational_information['organizations'].map { |item| "#{item['level']} #{item['name']}" }.reject(&:blank?).join(' » ')
  end

  def organizational_position
    organizational_positions.fetch('positions', {}).map { |item| item['position'] }.reject(&:blank?).join(' / ')
  end
end
