# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Darjeelink::RebrandlyImporter do
  let(:api) { double }

  before do
    allow(Rebrandly::Api).to receive(:new).and_return(api)
  end

  describe 'import' do
    let(:rebrandly_link_1) do
      link = Rebrandly::Link.new
      link.id = '1'
      link.slashtag = 'foo'
      link.destination = 'https://foo.com'
      link.clicks = 0

      link
    end

    let(:rebrandly_link_1_duplicate_slashtag) do
      link = Rebrandly::Link.new
      link.id = '5'
      link.slashtag = 'foo'
      link.destination = 'https://bar.com'
      link.clicks = 0

      link
    end

    let(:rebrandly_link_2) do
      link = Rebrandly::Link.new
      link.id = '2'
      link.slashtag = 'bar'
      link.destination = 'https://bar.com'
      link.clicks = 50

      link
    end

    let(:rebrandly_link_3) do
      link = Rebrandly::Link.new
      link.id = '3'
      link.slashtag = 'foobar'
      link.destination = 'https://foo.com/bar'
      link.clicks = 134

      link
    end

    let(:unused_rebrandly_link) do
      link = Rebrandly::Link.new
      link.id = '4'
      link.slashtag = 'test'
      link.destination = 'https://example.com'
      link.clicks = 4

      link
    end

    it 'calls the api links endpoint' do
      allow(api).to receive(:link_count).and_return(3)

      expect(api).to receive(:links)
        .with(last: nil)
        .and_return([rebrandly_link_1, rebrandly_link_2])

      expect(Darjeelink::ShortLink)
        .to receive(:create!)
        .with(url: 'https://foo.com', shortened_path: 'foo', visits: 0)

      expect(Darjeelink::ShortLink)
        .to receive(:create!)
        .with(url: 'https://bar.com', shortened_path: 'bar', visits: 50)

      expect(api).to receive(:links).with(last: '2').and_return([rebrandly_link_3])

      expect(Darjeelink::ShortLink)
        .to receive(:create!)
        .with(url: 'https://foo.com/bar', shortened_path: 'foobar', visits: 134)

      expect(Darjeelink::ShortLink)
        .not_to receive(:create!)
        .with(url: 'https://example.com', shortened_path: 'test', visits: 4)

      Darjeelink::RebrandlyImporter.new.import
    end

    context 'when different urls have the same slashtag' do
      it 'handles the error and logs duplicates for manual fixing' do
        allow(api).to receive(:link_count).and_return(2)
        expect(api)
          .to receive(:links)
          .with(last: nil)
          .and_return([rebrandly_link_1, rebrandly_link_1_duplicate_slashtag])

        expect(Rails.logger).to receive(:info).with('Imported 1 links from Rebrandly')
        expect(Rails.logger).to receive(:warn).with("Duplicates:\nhttps://bar.com/foo")

        expect { Darjeelink::RebrandlyImporter.new.import }.not_to raise_error
      end
    end
  end
end
