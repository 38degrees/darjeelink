# frozen_string_literal: true

require 'rails_helper'

class Airbrake
  def self.notify(*args)
  end
end

RSpec.describe '/darjeelink/short_links requests', type: :request do
  describe '#index' do
    before { Darjeelink::ShortLink.create!(url: 'http://example.com', shortened_path: 'test') }

    it 'fetches all the shortlinks' do
      short_links = Darjeelink::ShortLink.none.paginate(page: '1', per_page: 20)

      expect(Darjeelink::ShortLink)
        .to receive_message_chain(:search, :order, :paginate)
        .with(nil)
        .with(id: 'desc')
        .with(page: '1', per_page: 20)
        .and_return(short_links)

      get(darjeelink.short_links_path(page: 1))

      expect(response.status).to eq 200
    end

    context 'when a query param is passed' do
      it 'passes the param into the search' do
        short_links = Darjeelink::ShortLink.none.paginate(page: '1', per_page: 20)

        expect(Darjeelink::ShortLink)
          .to receive_message_chain(:search, :order, :paginate)
          .with('foo')
          .with(id: 'desc')
          .with(page: '1', per_page: 20)
          .and_return(short_links)

        get(darjeelink.short_links_path(page: 1) + '&query=foo')

        expect(response.status).to eq 200
      end
    end
  end

  describe '#new' do
    it 'loads the page' do
      get(darjeelink.new_short_link_path)
      expect(response.status).to eq 200
    end
  end

  describe '#create' do
    it 'redirects to the index page' do
      post(
        darjeelink.short_links_path,
        params: { short_link: { url: 'https://example.org', shortened_path: '' } }
      )

      expect(response.status).to eq(302)
    end

    context 'when a url is passed' do
      context 'when no custom path is passed' do
        it 'creates a short link with a generated path' do
          post(
            darjeelink.short_links_path,
            params: { short_link: { url: 'https://example.org', shortened_path: '' } }
          )

          expect(Darjeelink::ShortLink.last.shortened_path.present?).to eq(true)
        end
      end

      context 'when a custom path is passed' do
        it 'creates a short link with the passed path' do
          post(
            darjeelink.short_links_path,
            params: { short_link: { url: 'https://example.org', shortened_path: 'test' } }
          )

          expect(Darjeelink::ShortLink.last.shortened_path).to eq('test')
        end
      end

      context 'when it is a duplicate custom path' do
        it 'displays a warning to the user' do
          expect(Darjeelink::ShortLink).to receive(:create!)
            .and_raise(ActiveRecord::RecordNotUnique)

          post(
            darjeelink.short_links_path,
            params: { short_link: { url: 'https://example.org', shortened_path: 'test' } }
          )

          expect(flash[:error]).to be_present
        end
      end

      context 'when the url is not valid' do
        it 'displays a warning to the user' do
          expect(Darjeelink::ShortLink).not_to receive(:create!)

          post(
            darjeelink.short_links_path,
            params: { short_link: { url: 'www.google.com', shortened_path: 'test' } } # No https:// bit - invalid
          )

          expect(flash[:error]).to be_present
        end
      end
    end

    context 'when no url is passed' do
      it 'doesnt create a short url' do
        expect(Darjeelink::ShortLink).not_to receive(:create!)
        post(
          darjeelink.short_links_path,
          params: { short_link: { url: '', shortened_path: 'test' } }
        )
      end
    end
  end

  describe '#edit' do
    let(:short_link) { Darjeelink::ShortLink.create!(url: 'http://example.com') }

    it 'is successful' do
      get(darjeelink.edit_short_link_path(short_link))
      expect(response.status).to eq 200
    end

    it 'looks up the short link by the id' do
      expect(Darjeelink::ShortLink)
        .to receive(:find)
        .with(short_link.id.to_s)
        .and_return(short_link)

      get(darjeelink.edit_short_link_path(short_link))
    end
  end

  describe '#update' do
    let(:short_link) do
      Darjeelink::ShortLink.create!(url: 'http://example.com', shortened_path: 'test')
    end

    it 'is successful' do
      patch(
        darjeelink.short_link_path(short_link),
        params: { short_link: { url: 'https://example.co.uk' } }
      )

      expect(response.status).to eq 302
    end

    it 'updates the short link' do
      patch(
        darjeelink.short_link_path(short_link),
        params: { short_link: { url: 'https://example.co.uk', shortened_path: 'test2' } }
      )

      short_link.reload

      expect(short_link.url).to eq('https://example.co.uk')
      expect(short_link.shortened_path).to eq('test2')
    end
  end

  describe '#show' do
    context 'when the short link exists' do
      let!(:short_link) do
        Darjeelink::ShortLink.create!(url: 'http://example.com/', shortened_path: 'test')
      end

      it 'redirects you to the link' do
        expect(get("/#{short_link.shortened_path}"))
          .to redirect_to('http://example.com/')
      end

      it 'increases the visits count' do
        expect { get("/#{short_link.shortened_path}") }
          .to change { short_link.reload.visits }
          .by(1)
      end

      context 'when the short link has query params' do
        context 'when the base link has no query params' do
          it 'adds just the new query params' do
            query_params = '?foo=bar'
            expect(get("/#{short_link.shortened_path}#{query_params}"))
              .to redirect_to("http://example.com/#{query_params}")
          end
        end

        context 'when the base link has query params' do
          let(:short_link) do
            Darjeelink::ShortLink.create!(
              url: 'http://example.com/?test=true',
              shortened_path: 'test'
            )
          end

          it 'adds the new query params to the original query params' do
            expect(get("/#{short_link.shortened_path}?foo=bar"))
              .to redirect_to('http://example.com/?foo=bar&test=true')
          end

          context 'when both links have the same query param' do
            it 'uses the value of the new query param' do
              expect(get("/#{short_link.shortened_path}?test=false"))
                .to redirect_to('http://example.com/?test=false')
            end

            context 'when the new query param is empty' do
              it 'uses the value of the base query param' do
                expect(get("/#{short_link.shortened_path}?test"))
                  .to redirect_to('http://example.com/?test=true')
              end
            end
          end
        end
      end

      context 'when the short link has a different case' do
        it 'redirects you to the link' do
          expect(get('/TeSt'))
            .to redirect_to('http://example.com/')
        end
      end
    end

    context 'when the short link does not exist' do
      before do
        allow(Darjeelink).to receive(:fallback_url).and_return('https://fallback.com')
      end

      it 'redirects to the fallback' do
        expect(Rails.logger).to receive(:warn).with('ShortLink not found: test')

        expect(get('/test'))
          .to redirect_to('https://fallback.com')
      end
    end
  end
end
