# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Darjeelink::ShortLink do
  describe 'validations' do
    it 'requires a url' do
      expect { Darjeelink::ShortLink.create! }
        .to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Url can't be blank")
    end

    describe 'uniqueness' do
      context 'the exact shortened path already exists' do
        before do
          Darjeelink::ShortLink.create!(url: 'https://www.test.com', shortened_path: 'test')
        end

        it 'raises a unique violation error' do
          expect do
            Darjeelink::ShortLink.create!(url: 'https://www.test.com', shortened_path: 'test')
          end.to raise_error(ActiveRecord::RecordNotUnique)
        end
      end

      context 'the shortened path is the same, but with different case' do
        before do
          Darjeelink::ShortLink.create!(url: 'https://www.test.com', shortened_path: 'test')
        end

        it 'raises a unique violation error' do
          expect do
            Darjeelink::ShortLink.create!(url: 'https://www.test.com', shortened_path: 'TeSt')
          end.to raise_error(ActiveRecord::RecordNotUnique)
        end
      end
    end
  end

  describe 'after save' do
    context 'when no shortened_path is provided' do
      it 'generates a new one' do
        link = Darjeelink::ShortLink.create!(url: 'https://www.example.com', shortened_path: nil)
        expect(link.shortened_path).to be_present
      end
    end
  end

  describe 'before validation' do
    it 'strips whitespace' do
      link = Darjeelink::ShortLink.create!(url: 'https://www.example.com ', shortened_path: 'foo ')

      expect(link.url).to eq('https://www.example.com')
      expect(link.shortened_path).to eq('foo')
    end
  end

  describe '.search' do
    let!(:link1) do
      Darjeelink::ShortLink.create(url: 'https://www.test.com', shortened_path: 'foo')
    end
    let!(:link2) { Darjeelink::ShortLink.create(url: 'https://www.cat.com', shortened_path: 'dog') }

    context 'when query matches shortened_path' do
      it 'returns the matches' do
        expect(Darjeelink::ShortLink.search('fo')).to match_array([link1])
      end
    end

    context 'when query matches url' do
      it 'returns the matches' do
        expect(Darjeelink::ShortLink.search('test')).to match_array([link1])
      end
    end

    context 'when query matches nothing' do
      it 'returns the matches' do
        expect(Darjeelink::ShortLink.search('bar')).to match_array([])
      end
    end

    context 'when query is nil' do
      it 'returns all the links' do
        expect(Darjeelink::ShortLink.search(nil)).to match_array([link1, link2])
      end
    end
  end

  describe '.ifind' do
    context 'when there are no links' do
      it 'returns no match' do
        expect(Darjeelink::ShortLink.ifind('test')).to eq(nil)
      end
    end

    context 'when there are links' do
      let!(:link) do
        Darjeelink::ShortLink.create(url: 'https://www.test.com', shortened_path: 'test')
      end

      context 'when the query matches a link exactly' do
        it 'returns the matching link' do
          expect(Darjeelink::ShortLink.ifind('test')).to eq(link)
        end
      end

      context 'when the query matches the link but in a different case' do
        it 'return the matching link' do
          expect(Darjeelink::ShortLink.ifind('TeSt')).to eq(link)
        end
      end

      context 'when the query does not match the link' do
        it 'returns no link' do
          expect(Darjeelink::ShortLink.ifind('test1')).to eq(nil)
        end
      end
    end
  end
end
