require 'spec_helper'

describe Spyke::Kaminari::Relation do
  let(:model) { TestClient::Model }
  let(:names) { subject.map(&:name) }

  describe 'metadata' do
    describe '#total_count' do
      subject { model.send(scope).total_count }

      context 'all' do
        let(:scope) { :all }

        it 'returns the total count of records' do
          expect(subject).to eq(16)
        end
      end

      context 'citizens of Strong Badia' do
        let(:scope) { :strong_badians }

        it 'returns the total count of records' do
          expect(subject).to eq(6)
        end
      end
    end

    describe '#total_pages' do
      subject { model.send(scope).total_pages }

      context 'all' do
        let(:scope) { :all }

        it 'returns the number of pages' do
          expect(subject).to eq(4)
        end
      end

      context 'citizens of Strong Badia' do
        let(:scope) { :strong_badians }

        it 'returns the number of pages' do
          expect(subject).to eq(2)
        end
      end
    end

    describe '#limit_value' do
      context 'all' do
        subject { model.all.limit_value }

        it 'returns the default (5) per-page value' do
          expect(subject).to eq(5)
        end
      end

      context 'per-page' do
        subject { model.per_page(8).limit_value }

        it 'returns the specified per-page value' do
          expect(subject).to eq(8)
        end
      end
    end

    describe '#current_page' do
      subject { model.page(number).current_page }

      context 'page 1' do
        let(:number) { 1 }

        it 'returns the current page number' do
          expect(subject).to eq(1)
        end
      end

      context 'page 2' do
        let(:number) { 2 }

        it 'returns the current page number' do
          expect(subject).to eq(2)
        end
      end
    end

    describe '#next_page' do
      subject { model.page(number).next_page }

      context 'page 3' do
        let(:number) { 3 }

        it 'returns the next page number' do
          expect(subject).to eq(4)
        end
      end

      context 'page 4' do
        let(:number) { 4 }

        it 'returns nothing (there is no next page)' do
          expect(subject).to be_nil
        end
      end
    end

    describe '#prev_page' do
      subject { model.page(number).prev_page }

      context 'page 1' do
        let(:number) { 1 }

        it 'returns nothing (there is no previous page)' do
          expect(subject).to be_nil
        end
      end

      context 'page 2' do
        let(:number) { 2 }

        it 'returns the previous page number' do
          expect(subject).to eq(1)
        end
      end
    end

    describe '#offset_value' do
      context 'all' do
        subject { model.all.offset_value }

        it 'returns the default (0) offset value' do
          expect(subject).to eq(0)
        end
      end

      context 'offset' do
        subject { model.offset(7).offset_value }

        it 'returns the specified offset value' do
          expect(subject).to eq(7)
        end
      end
    end
  end

  describe 'helpers' do
    describe '#first_page?' do
      subject { model.page(number).first_page? }

      context 'page 1' do
        let(:number) { 1 }

        it 'returns true' do
          expect(subject).to eq(true)
        end
      end

      context 'page 4' do
        let(:number) { 4 }

        it 'returns false' do
          expect(subject).to eq(false)
        end
      end
    end

    describe '#last_page?' do
      subject { model.page(number).last_page? }

      context 'page 1' do
        let(:number) { 1 }

        it 'returns false' do
          expect(subject).to eq(false)
        end
      end

      context 'page 4' do
        let(:number) { 4 }

        it 'returns true' do
          expect(subject).to eq(true)
        end
      end
    end

    describe '#out_of_range?' do
      subject { model.page(number).out_of_range? }

      context 'page 1' do
        let(:number) { 1 }

        it 'returns false' do
          expect(subject).to eq(false)
        end
      end

      context 'page 5' do
        let(:number) { 5 }

        it 'returns true' do
          expect(subject).to eq(true)
        end
      end
    end

    describe '#each_page' do
      subject { model.all.each_page }

      it 'returns an enumerable' do
        expect(subject.count).to eq(4)
      end

      it 'enumerates through each page' do
        pages = subject.map(&:current_page)

        expect(pages).to eq([1, 2, 3, 4])
      end

      it 'can be used to collect all records' do
        records = subject.flat_map(&:to_a)

        expect(records.count).to eq(16)
        expect(records.first.name).to eq('The King of Town')
        expect(records.last.name).to eq('Cinder Block')
      end

      it 'only makes 1 request per page' do
        expect { subject.map(&:current_page) }.to change { request_count }.by(4)
      end
    end
  end
end
