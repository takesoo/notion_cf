# frozen_string_literal: true

RSpec.describe NotionCf::Resources do
  describe '#deploy' do
    context 'when blueprints is empty' do
      it 'does not call block_append_children' do
        client = instance_double('NotionCf::NotionApiClient')
        page_id = 'page_id'
        resources = NotionCf::Resources.new(page_id:)
        blueprints = []
        expect(client).not_to receive(:block_append_children)
        resources.deploy(blueprints)
      end
    end

    context 'block_resource' do
      let(:page_id) { 'page_id' }
      let(:resources) { NotionCf::Resources.new(page_id:) }
      let(:attribute) { { paragraph: {} } }
      let(:block_resource) { instance_double('NotionCf::BlockResource') }

      context 'when blueprints does not have id' do
        let(:client) do
          instance_double('NotionCf::NotionApiClient').tap do |client|
            allow(NotionCf::NotionApiClient).to receive(:new).and_return(client)
            allow(client).to receive(:block_append_children).and_return({ id: 'block_id', type: 'paragraph' })
          end
        end
        let(:blueprints) { [{ type: 'paragraph' }.merge(attribute)] }

        it 'call block_append_children' do
          expect(client).to receive(:block_append_children).with(block_id: page_id, children: [attribute])
          expect(resources.deploy(blueprints)).to be_truthy
        end
      end

      context 'when blueprints has id' do
        let(:client) do
          instance_double('NotionCf::NotionApiClient').tap do |client|
            allow(NotionCf::NotionApiClient).to receive(:new).and_return(client)
            allow(client).to receive(:update_block).and_return({ id: 'block_id', type: 'paragraph' })
          end
        end
        let(:blueprints) { [{ id: 'block_id', type: 'paragraph' }.merge(attribute)] }

        it 'call update_block' do
          expect(client).to receive(:update_block).with(id: 'block_id', parameter: attribute)
          expect(resources.deploy(blueprints)).to be_truthy
        end
      end
    end

    context 'database_resource' do
      let(:page_id) { 'page_id' }
      let(:resources) { NotionCf::Resources.new(page_id:) }
      let(:block_resource) { instance_double('NotionCf::BlockResource') }

      context 'when blueprints does not have id' do
        let(:client) do
          instance_double('NotionCf::NotionApiClient').tap do |client|
            allow(NotionCf::NotionApiClient).to receive(:new).and_return(client)
            allow(client).to receive(:create_database).and_return({ id: 'block_id', type: 'child_database' })
          end
        end
        let(:blueprints) { [{ type: 'child_database', child_database: { title: 'database' } }] }

        it 'call create_database' do
          expect(client).to receive(:create_database).with({ parent: { page_id: }, title: 'database' })
          expect(resources.deploy(blueprints)).to be_truthy
        end
      end

      context 'when blueprints has id' do
        let(:client) do
          instance_double('NotionCf::NotionApiClient').tap do |client|
            allow(NotionCf::NotionApiClient).to receive(:new).and_return(client)
            allow(client).to receive(:update_database).and_return({ id: 'database_id', type: 'child_database' })
          end
        end
        let(:blueprints) { [{ id: 'database_id', type: 'child_database', child_database: { title: 'database' } }] }

        it 'call update_database' do
          expect(client).to receive(:update_database).with(database_id: 'database_id', parameter: { title: 'database' })
          expect(resources.deploy(blueprints)).to be_truthy
        end
      end
    end

    context 'page_resource' do
      let(:page_id) { 'page_id' }
      let(:resources) { NotionCf::Resources.new(page_id:) }
      let(:block_resource) { instance_double('NotionCf::BlockResource') }

      context 'when blueprints does not have id' do
        let(:client) do
          instance_double('NotionCf::NotionApiClient').tap do |client|
            allow(NotionCf::NotionApiClient).to receive(:new).and_return(client)
            allow(client).to receive(:create_page).and_return({ parent: { page_id: 'page_id' } })
          end
        end
        let(:blueprints) { [{ type: 'child_page', child_page: {} }] }

        it 'call create_page' do
          expect(client).to receive(:create_page).with({ parent: { page_id: 'page_id' } })
          expect(resources.deploy(blueprints)).to be_truthy
        end
      end

      context 'when blueprints has id' do
        let(:client) do
          instance_double('NotionCf::NotionApiClient').tap do |client|
            allow(NotionCf::NotionApiClient).to receive(:new).and_return(client)
            allow(client).to receive(:update_page).and_return({ id: 'page_id', type: 'child_page', child_page: {} })
          end
        end
        let(:blueprints) { [{ id: 'page_id', type: 'child_page', child_page: {} }] }

        it 'call update_page' do
          expect(client).to receive(:update_page).with(page_id: 'page_id', parameter: {})
          expect(resources.deploy(blueprints)).to be_truthy
        end
      end
    end
  end
end
