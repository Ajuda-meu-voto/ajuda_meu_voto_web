class Ajudameuvoto::Tse::Csv::ElectionResult::RowParser
  def parse_politician(row)
    {
      cpf: row['NR_CPF_CANDIDATO'].strip,
      name: row['NM_CANDIDATO'].strip.downcase,
      nickname: row['NM_URNA_CANDIDATO'].strip.downcase,
      email: row['NM_EMAIL'].strip.downcase,
      nationality: data_normalizer.nationality(row['CD_NACIONALIDADE'].strip),
      birthdate: data_normalizer.birthdate(row['DT_NASCIMENTO'].strip),
      gender: data_normalizer.gender(row['CD_GENERO'].strip),
      marital_status: data_normalizer.marital_status(row['CD_ESTADO_CIVIL'].strip),
      ethnicity: data_normalizer.ethnicity(row['CD_COR_RACA'].strip),
      education_level: data_normalizer.education_level(row['CD_GRAU_INSTRUCAO'].strip)
    }
  end

  def parse_election_result(row)
    {
      year: row['ANO_ELEICAO'].strip.to_i,
      party: {
        shortname: row['SG_PARTIDO'].strip.upcase,
        name: row['NM_PARTIDO'].strip.downcase
      },
      role: data_normalizer.role(row['CD_CARGO'].strip.downcase),
      state: row['SG_UF'].strip.upcase,
      municipality: row['NM_UE'].strip.downcase,
      elected?: data_normalizer.elected?(row['CD_SIT_TOT_TURNO'].strip),
      tse_ue: row['SG_UE'].strip,
      tse_candidate_number: row['SQ_CANDIDATO'].strip
    }
  end

  private

  def data_normalizer
    @data_normalizer ||= Ajudameuvoto::Tse::Csv::ElectionResult::DataNormalizer.new
  end
end
