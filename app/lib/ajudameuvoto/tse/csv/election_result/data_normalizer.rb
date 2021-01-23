class Ajudameuvoto::Tse::Csv::ElectionResult::DataNormalizer
  def nationality(raw_data)
    return 'brasileira' if %w[1 2].include?(raw_data.to_s)

    'other'
  end

  def birthdate(raw_data)
    Date.strptime raw_data, '%d/%m/%Y'
  end

  def gender(raw_data)
    raw_data = raw_data.to_i

    return 'male' if raw_data == 2
    return 'female' if raw_data == 4

    raise StandardError, "Non-expected gender code: #{raw_data}"
  end

  def marital_status(raw_data)
    raw_data = raw_data.to_i

    return 'single' if raw_data == 1
    return 'married' if raw_data == 3
    return 'divorced' if raw_data == 9

    'other'
  end

  def ethnicity(raw_data)
    raw_data = raw_data.to_i

    return 'branca' if raw_data == 1
    return 'preta' if raw_data == 2
    return 'parda' if raw_data == 3
    return 'amarela' if raw_data == 4
    return 'indígena' if raw_data == 5
    return 'other' if raw_data == 6

    raise StandardError, "Non-expected ethnicity code: #{raw_data}"
  end

  def role(raw_data)
    raw_data = raw_data.to_i

    return 'segundo suplente' if raw_data == 10
    return 'primeiro suplente' if raw_data == 9
    return 'deputado estadual' if raw_data == 7
    return 'deputado federal' if raw_data == 6
    return 'senador' if raw_data == 5
    return 'vice-governador' if raw_data == 4
    return 'governador' if raw_data == 3
    return 'vereador' if raw_data == 13
    return 'vice-prefeito' if raw_data == 12
    return 'prefeito' if raw_data == 11

    raise StandardError, "Non-expected role code: #{raw_data}"
  end

  def elected?(raw_data)
    [1, 2, 3, 5].include?(raw_data.to_i)
  end

  def education_level(raw_data)
    raw_data = raw_data.to_i

    return 'ensino médio completo' if raw_data == 6
    return 'superior completo' if raw_data == 8
    return 'ensino fundamental completo' if raw_data == 4
    return 'ensino fundamental incompleto' if raw_data == 3
    return 'lê e escreve' if raw_data == 2
    return 'ensino médio incompleto' if raw_data == 5
    return 'superior incompleto' if raw_data == 7
    return 'analfabeto' if raw_data == 1

    raise StandardError, "Non-expected education_level code: #{raw_data}"
  end
end
