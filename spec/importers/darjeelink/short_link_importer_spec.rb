# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Darjeelink::ShortLinkImporter do
  let(:test_data_path) { "#{::Rails.root}/../importers/test_data/short_links.csv" }

  describe 'import' do
    it 'imports the csv' do
      expect(Darjeelink::ShortLink)
        .to receive(:create!)
        .with(url: 'https://foo.com', shortened_path: 'foo')

      expect(Darjeelink::ShortLink)
        .to receive(:create!)
        .with(url: 'https://bar.com', shortened_path: 'custom')

      expect(Darjeelink::ShortLink)
        .to receive(:create!)
        .with(url: 'https://foobar.com', shortened_path: 'foobar')

      Darjeelink::ShortLinkImporter.new(test_data_path).import
    end

    context 'when different urls have the same custom path' do
      let(:test_data_path) { "#{::Rails.root}/../importers/test_data/short_links_duplicates.csv" }

      it 'handles the error and logs duplicates for manual fixing' do
        expect(Rails.logger).to receive(:warn).with("Duplicates:\nhttps://bar.com/foo")

        expect { Darjeelink::ShortLinkImporter.new(test_data_path).import }.not_to raise_error
      end
    end
  end
end
