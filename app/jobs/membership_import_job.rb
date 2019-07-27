class MembershipImportJob < ApplicationJob
  queue_as :membership_list

  def perform(membership_upload)
    CSVReader.new(membership_upload.csv_file).each_line do |row, index|
      begin
        save_membership row
      rescue StandardError => e
        logger.error "The following error was found at line ##{index}: #{e}"
      end
    end
  ensure
    membership_upload.csv_file.purge
  end

  private

  def save_membership(row)
    membership = Membership.where(id: row['Cód. Membro']).first_or_initialize
    membership.name = name(row)
    membership.joining_date = joining_date(row)
    membership.organizational_position = organizational_position(row) 
    membership.study_level = study_level(row) 
    membership.sustaining_contribution = sustaining_contribution(row) 
    membership.discussion_meeting = discussion_meeting(row) 
    membership.publications_subscriptions = publications_subscriptions(row) 
    membership.members_sponsored = members_sponsored(row) 
    membership.organizational_information = organizational_information(row) 
    membership.save
  end

  def name(row)
    row['Nome'].strip
  end

  def joining_date(row)
    joining_date = row['Conversão']
    Date.strptime(joining_date, '%d/%m/%Y') if joining_date != 'N/A'
  end

  def organizational_position(row)
    organizational_position = row['Função'].strip
    organizational_position == 'N/A' ? '' : organizational_position
  end

  def study_level(row)
    study_level = row['Grau Budismo'].strip
    study_level == 'N/A' ? '' : study_level
  end

  def sustaining_contribution(row)
    row['Kofu'].strip.to_i == 1
  end

  def discussion_meeting(row)
    last_attendance = row['Última RP'].strip
    return {} if last_attendance == 'N/A'
    /(?<type>.*) [(](?<date>.*)[)] > (?<organization>.*)/ =~ last_attendance
    {
      last_attendance: {
        type: type,
        date: Date.strptime("1/#{date}", '%d/%m/%Y').end_of_month,
        organization: organization
      }
    }
  end

  def publications_subscriptions(row)
    {
      bsp: row['BSP'].strip.to_i == 1,
      tc: row['TC'].strip.to_i == 1,
      rdez: row['R10'].strip.to_i == 1
    }
  end

  def members_sponsored(row)
    {
      total: row['Shakubukus'].strip.to_i
    }
  end

  def organizational_information(row)
    organizational_information = []
    all_but_first = row['Organização'].strip.split(';')[1..-1]
    all_but_first.each do |organization|
      /(?<level>Coor. Geral|Coor.|Sub.|RM\/RE|Regional|Área|Distrito|Comunidade|Bloco) (?<name>.*) [(](?<code>.*)[)]/ =~ organization
      organizational_information << { level: level, code: code.to_i, name: name } if level.present?
    end
    { organizations: organizational_information }
  end

end
