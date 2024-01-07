# frozen_string_literal: true

RSpec.describe NotionCf::Template do
  describe '.build_from_file' do
    context 'when file is not specified' do
      it 'raise error' do
        expect { NotionCf::Template.build_from_file(file_path: nil) }.to raise_error(ArgumentError)
      end
    end

    context 'when file is specified' do
      it 'return Template instance' do
        file_path = File.expand_path('fixtures/notion_cf/sample.yaml', File.dirname(__dir__))
        template = NotionCf::Template.build_from_file(file_path:)
        expect(template).to be_a(NotionCf::Template)
      end
    end
  end

  describe '#create' do
    it 'create yaml file' do
      template = NotionCf::Template.new(blueprints: [{ id: 'block_id', type: 'paragraph' }])
      file_path = 'templates/page_id.yaml'
      allow(File).to receive(:open).with(file_path, 'w')
      result = template.create('page_id')
      expect(File).to have_received(:open).with(file_path, 'w')
      expect(result).to eq(file_path)
    end
  end
end
