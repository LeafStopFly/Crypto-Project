describe 'Getting Document' do before do
    @proj = Credence::Project.first DATA[:documents].each do |doc_data|
    Credence::CreateDocumentForProject.call( project_id: @proj.id,
    document_data: doc_data
    ) end
    end