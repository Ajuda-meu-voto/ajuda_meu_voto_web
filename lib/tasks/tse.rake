namespace :tse do
  desc 'Le e salva os dados de eleições de um estado a partir do CSV do tse.jus.br'
  task :processar_resultado_eleicoes_csv, [:csv_path] => :environment do |_task, args|
    Rails.logger = Logger.new($stdout)
    Rails.logger.level = Logger::DEBUG
    ActiveRecord::Base.logger = Logger.new($stdout)

    Rails.logger.debug 'Iniciando rake task'
    Ajudameuvoto::Tse::Csv::ElectionResult::Process.new.call(csv_path: args.csv_path)
    Rails.logger.debug 'Finalizado.'
  end

  desc 'Faz o download (tse.jus.br) e importa as fotos dos candidatos por ano de eleição e estado'
  task :importar_fotos_candidatos, %i[ano_eleicao uf] => :environment do |_task, args|
    Rails.logger = Logger.new($stdout)
    Rails.logger.level = Logger::DEBUG
    ActiveRecord::Base.logger = Logger.new($stdout)

    Rails.logger.debug 'Iniciando rake task'
    Ajudameuvoto::Tse::Photos::ImportPoliticianPhotos.new.call(election_year: args.ano_eleicao,
                                                               state_shortname: args.uf)
  end
end
