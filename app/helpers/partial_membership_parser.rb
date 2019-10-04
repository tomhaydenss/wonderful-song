class PartialMembershipParser
  ALLOWED_DIVISIONS = %w[DMJ DEM]

  def parse(row)
    return unless ALLOWED_DIVISIONS.include? row['Divisão']

    membership = Membership.where(id: row['Cód. Membro']).first_or_initialize
    membership.name = name(row)
    membership.joining_date = joining_date(row)
    membership.birthdate = birthdate(row)
    membership.organizational_positions = organizational_positions(row) 
    membership.study_level = study_level(row) 
    membership.sustaining_contribution = sustaining_contribution(row) 
    membership.publications_subscriptions = publications_subscriptions(row) 
    membership.organizational_information = organizational_information(row) 
    membership.email = email(row)
    membership.phones = phones(row)
    membership
  end

  private

  def name(row)
    row['Nome'].strip
  end

  def joining_date(row)
    joining_date = row['Conversão']
    Date.strptime(joining_date[0..9], '%d/%m/%Y') if joining_date != 'não informado'
  end

  def birthdate(row)
    birthdate = row['Nascimento']
    Date.strptime(birthdate[0..9], '%d/%m/%Y') if birthdate != 'não informado'
  end

  def organizational_positions(row)
    positions = row['Funções'].strip
    return {} if positions == '-'

    organizational_positions = positions.split(' / ').inject([]) do |array, organizational_position|
      /(?<position>.*) (?<division>DE|DMJ|DJ|Futuro|Esperança|Herdeiros|Universitários) \(.*/ =~ organizational_position.strip
      array << { position: position, division: division } if position.present?
    end
    { positions: organizational_positions }
  end

  def study_level(row)
    study_level = row['Grau Budismo'].strip
  end

  def sustaining_contribution(row)
    row['Kofu'].strip == 'sim'
  end

  def publications_subscriptions(row)
    {
      bsp: row['BSP'].strip.to_i == 1,
      tc: row['TC'].strip.to_i == 1,
      rdez: row['R10'].strip.to_i == 1
    }
  end

  def organizational_information(row)
    organizational_information = []
    row['Organização'].strip.split(' / ').each do |organization|
      /(?<level>Coor. Geral|Coor.|Sub.|RM\/RE|Regional|Área|Distrito|Comunidade|Bloco) (?<name>.*)/ =~ organization.strip
      organizational_information << { level: level, name: name } if level.present?
    end
    { organizations: organizational_information }
  end

  def email(row)
    row['E-mail']
  end

  def phones(row)
    phones = []
    phones << row['Tel. Res.']
    phones << row['Tel. Com.']
    phones << row['Celular']
    { phones: phones.compact }.compact
  end
end