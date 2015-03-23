require 'spec_helper'

describe Spyke::Kaminari::Scopes do
  let(:model) { TestClient::Model }
  let(:names) { subject.map(&:name) }

  describe '.all' do
    subject { model.all }

    it 'returns the default (the first) page of records' do
      expect(names).to eq(['The King of Town', 'Strong Mad', 'Marzipan', 'Homestar Runner', 'Coach Z'])
    end
  end

  describe '.page' do
    subject { model.page(number) }

    context 'page 1' do
      let(:number) { 1 }

      it 'returns the first page of records' do
        expect(names).to eq(['The King of Town', 'Strong Mad', 'Marzipan', 'Homestar Runner', 'Coach Z'])
      end
    end

    context 'page 2' do
      let(:number) { 2 }

      it 'returns the second page of records' do
        expect(names).to eq(['Pom Pom', 'Strong Sad', 'The Cheat', 'The Poopsmith', 'Strong Bad'])
      end
    end
  end

  describe '.per_page' do
    subject { model.per_page(3).page(number) }

    context 'page 1' do
      let(:number) { 1 }

      it 'returns only 3 records per page' do
        expect(names).to eq(['The King of Town', 'Strong Mad', 'Marzipan'])
      end
    end

    context 'page 2' do
      let(:number) { 2 }

      it 'returns only 3 records per page' do
        expect(names).to eq(['Homestar Runner', 'Coach Z', 'Pom Pom'])
      end
    end
  end

  describe '.offset' do
    subject { model.offset(2) }

    it 'skips the first 2 records' do
      expect(names).to eq(['Marzipan', 'Homestar Runner', 'Coach Z', 'Pom Pom', 'Strong Sad'])
    end
  end

  describe 'scope chaining' do
    context 'user-defined first' do
      subject { model.strong_badians.page(2) }

      it 'is supported' do
        expect(names).to eq(['Cinder Block'])
      end
    end

    context 'library-provided first' do
      subject { model.page(2).strong_badians }

      it 'is supported' do
        expect(names).to eq(['Cinder Block'])
      end
    end
  end

  describe 'relation' do
    subject { model.all.class }

    context 'module included' do
      it 'is extended with pagination features' do
        expect(subject).to eq(Spyke::Kaminari::Relation)
      end
    end

    context 'module not included' do
      let(:model) do
        Class.new(Spyke::Base) do
          def self.model_name; 'Dangeresque'; end
          uri 'characters'
        end
      end

      it 'is unaffected' do
        expect(subject).to eq(Spyke::Relation)
      end
    end
  end
end
