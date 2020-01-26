# frozen_string_literal: true

module StatisticHelper
  def self.levels
    { second_level: 2, third_level: 3 }
  end

  def self.members_total(permitted_ensembles_only)
    Member.for_statistic.permitted_ensembles_only(permitted_ensembles_only).count
  end

  def self.members_total_by_status(permitted_ensembles_only)
    Member.for_statistic.permitted_ensembles_only(permitted_ensembles_only).group('statuses.description').count
  end

  def self.subscribers_total(permitted_ensembles_only)
    Member
      .includes(:membership)
      .for_statistic
      .permitted_ensembles_only(permitted_ensembles_only)
      .each_with_object('Sim' => 0, 'Não' => 0) do |member, hash|
      key = member.membership&.subscribed_to_publications? ? 'Sim' : 'Não'
      hash[key] = hash[key] + 1
    end.sort_by(&:first).reverse.to_h
  end

  def self.ensembles_to_analyze(level, permitted_ensembles_only)
    permitted_ensembles_only.each_with_object([]) do |ensemble, array|
      array << ensemble.ensemble_parent_at_level(levels[level])
    end.reject(&:blank?).uniq
  end

  def self.members_total_by_ensemble_level(level, permitted_ensembles_only)
    ensembles_to_analyze(level, permitted_ensembles_only).each_with_object({}) do |ensemble, hash|
      ensembles = ensemble.filterable_ensembles
      members_total = Member.for_statistic.permitted_ensembles_only(ensembles).count
      short_name = ensemble.name.sub('Taiyo Ongakutai ', '')
      key = "#{short_name} (#{members_total})"
      hash[key] = members_total
    end
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/LineLength
  def self.subscribers_by_ensemble_level(level, permitted_ensembles_only)
    result = ensembles_to_analyze(level, permitted_ensembles_only).each_with_object(subscribers: [], not_subscribers: []) do |ensemble, hash|
      ensembles = ensemble.filterable_ensembles
      members = Member.includes(:membership).for_statistic.permitted_ensembles_only(ensembles)
      subscribers = members.select { |member| member.membership.subscribed_to_publications? }.count
      not_subscribers = members.count - subscribers

      short_name = ensemble.name.sub('Taiyo Ongakutai ', '')
      hash[:subscribers] << [short_name, subscribers]
      hash[:not_subscribers] << [short_name, not_subscribers]
    end
    [{ name: 'Sim', data: result[:subscribers] }, { name: 'Não', data: result[:not_subscribers] }]
  end
  # rubocop:enable Metrics/LineLength
  # rubocop:enable Metrics/AbcSize

  def self.members_total_by_ensemble(ensemble_parent)
    return {} if ensemble_parent.blank?

    ensemble_parent.filterable_ensembles.each_with_object({}) do |ensemble, hash|
      members_total = Member.for_statistic.permitted_ensembles_only([ensemble]).count
      short_name = ensemble.name.sub('Taiyo Ongakutai ', '')
      key = "#{short_name} (#{members_total})"
      hash[key] = members_total
    end
  end

  # rubocop:disable Metrics/AbcSize
  def self.subscribers_by_ensemble(ensemble_parent)
    return [] if ensemble_parent.blank?

    result = ensemble_parent.filterable_ensembles.each_with_object(subscribers: [], not_subscribers: []) do |ensemble, hash|
      members = Member.includes(:membership).for_statistic.permitted_ensembles_only([ensemble])
      subscribers = members.select { |member| member.membership.subscribed_to_publications? }.count
      not_subscribers = members.count - subscribers

      short_name = ensemble.name.sub('Taiyo Ongakutai ', '')
      hash[:subscribers] << [short_name, subscribers]
      hash[:not_subscribers] << [short_name, not_subscribers]
    end
    [{ name: 'Sim', data: result[:subscribers] }, { name: 'Não', data: result[:not_subscribers] }]
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable  Metrics/AbcSize
  # rubocop:disable  Metrics/MethodLength
  def self.members_total_by_status_by_ensemble(ensemble_parent)
    return [] if ensemble_parent.blank?

    permitted_ensembles_only = ensemble_parent.filterable_ensembles
    result = Member.for_statistic.permitted_ensembles_only(permitted_ensembles_only).group('ensembles.name', 'statuses.description').count
    to_inject = result.map { |k, _v| k.last }.uniq.map { |item| { name: item, data: [] } }
    converted_result = result.each_with_object(to_inject) do |data_item, array|
      data = [data_item.first.first, data_item.last]
      idx = array.index { |item| item[:name] == data_item.first.last }
      array[idx][:data] << data
      array
    end
    converted_result
  end
  # rubocop:enable  Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
end
