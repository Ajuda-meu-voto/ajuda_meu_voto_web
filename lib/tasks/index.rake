namespace :index do
  desc 'Indexa políticos, partidos e estados para a busca principal do site'
  task politicians: :environment do
    Ajudameuvoto::Index::IndexStates.new.call
    Ajudameuvoto::Index::IndexParties.new.call
    Ajudameuvoto::Index::IndexPoliticians.new.call
  end
end
