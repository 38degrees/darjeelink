# Darjeelink

## What is it?
Darjeelink is a very simple link shortener gem.
Authorized users can create shortened links.
The shortened link can be visited by anyone, and they are redirected to the original link.

Authorisation is handled by Google oauth.

It needs to be mounted inside a rails app to be used.

### Analytics
It tracks the number of times a link has been clicked.  This is the only metric that is tracked.

### UTM
There is a UTM generator, where you can provide:
- a base url
- a source and medium
- a campaign identifier
And you can get a link with UTM params all filled in, and shortern it with one click.

## Installation
### Gemfile
Add these lines to your app's Gemfile
```
gem 'darjeelink'
gem 'repost' # Shouldn't be required, but it is.  Investigate why
```

### Mounting the engine
Add these lines to your app's routes.rb
```
mount Darjeelink::Engine => "/"

# Go to short links
get '/:id' => "shortener/shortened_urls#show"
```

### Set the environment variables

#### Required
- DATABASE_URL

##### For Google Oauth:
- AUTH_DOMAIN
- GOOGLE_API_CLIENT_ID
- GOOGLE_API_CLIENT_SECRET

#### Optional
- FALLBACK_URL - If someone tries to visit a link that does not exist then they will go here.
- PERMITTED_IPS - If you want to admin access to certain IP addresses then use this setting.
- REBRANDLY_API_KEY - Used to fetch links from rebrandly if importing old links from there.

## Adding new UTM options
In `config/initializers/darjeelink.rb` edit the `config.source_mediums` hash.

Each key is a hyphenated source-medium.  If you just want the source then omit the hyphen and medium.

Each value is a slightly more readable version for display.

## Development
The recommended approach is to use Vagrant. `vagrant up` will create an isolated darjeelink instance.
Before you run `vagrant up`, make sure to create `.env.development` & `.env.test` files as detailed below.

### Setup development environment
Run `cp .env.sample spec/dummy/.env.development`

Nothing else required

### Setup test environment
Run `cp .env.sample spec/dummy/.env.test`

Change the database url to be different to the development one i.e. `postgres://darjeelink_dbuser:password@localhost/darjeelink-test`

## Releasing
Darjeelink follows [Semantic Versioning](https://semver.org)

Once all necessary changes have made it in to master and you are ready to do a release you need to do these steps.

Note that if you are running in a vagrant VM, most of these steps can be done from within the VM.

- Update `lib/darjeelink/version.rb` to the new version
- Run `bundle install` to pick up the change in Gemfile.lock
- Commit the changes to `lib/darjeelink/version.rb` and `Gemfile.lock`, and push them to GitHub
- Go to `https://github.com/38dgs/darjeelink/releases` and create a release tag in GitHub
- Run `gem build darjeelink.gemspec` this will output a file `darjeelink-X.X.X.gem` the version should match what version.rb and github.
- Run `gem push darjeelink-X.X.X.gem`

## GDPR
No personally identifiable data is stored about the public by this gem.
It does not store information on individual clicks, only a counter of how many times a link has been clicked.
There are no cookies required to visit a short link.

For the admin side there is a session cookie that stores information in the session cookie
TODO: LIMIT THIS TO EMAIL

## Contributing
This gem has been developed by 38 Degrees to meet our link shortening needs.
To Contribute, create a PR, Doesn't have to be from a fork

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
