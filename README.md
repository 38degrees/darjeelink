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

## API
There is an API available to create short links.
To create a short link via the API:

First, create an api token `Darjeelink::ApiToken.create!(username: <username>, active: true)`.
Then grab the token.

Next, make a request
```
POST /api
Authorization => Token token=<username>:<token>
{
  short_link: {
    url: 'https://www.example.com',
    shortened_path: 'xmpl' (optional)
  }
}
```
`url` is the absolute URI that you wish to shorten
`shortened_path` is the path that you will visit to get redirected to your original link.  It is optional.  If it is not provided one will be generated automatically

If successful you will get a response like:
```
STATUS 201
{
  short_link: <shortened_url>
}
```

If unsuccessful you will get a response like
```
STATUS 400
{
  error: "information on what went wrong"
}
```

If authorization failed you will get a response like
```
STATUS 401
{}
```
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

Docker can be used to run tests easily - 'docker-compose up' should run the unit tests.

Another approach is to use Vagrant. `vagrant up` will create an isolated darjeelink instance.
Before you run `vagrant up`, make sure to create `.env.development` & `.env.test` files as detailed below.

### Setup development environment
Run `cp .env.sample spec/dummy/.env.development`

Nothing else required

### Setup test environment
Run `cp .env.sample spec/dummy/.env.test`

Change the database url to be different to the development one i.e. `postgres://darjeelink_dbuser:password@localhost/darjeelink-test`

## Releasing
Darjeelink follows [Semantic Versioning](https://semver.org)

### Pre-releasing - Staging tests
There are several ways to test the gem before releasing it.

One way, is to check the new development branch into Github, and then use `portkey-app` to test it in a staging environment.

- Create a new branch in the `darjeelink` repo with a sensible name related to your intended release: e.g. `darjeelink-v0.14.6-upgrade`.
  - Perform the required upgrades, security patching, etc for the new release.
  - Bump the version number as required (see below).
- Create a new branch in the `portkey-app` repo with a sensible name related to your intdended release: e.g. `darjeelink-v0.14.6-upgrade`.
- In the `Gemfile` of the portkey-app repo, change the `darjeelink` gem to point to the branch you just created in the darjeelink repo.
  ```gemfile
  # Actual URL Shortener
  # gem 'darjeelink' <-- Temporarilly change this. Remeber to change it back, and run bundle install to update the Gemfile.lock when done!
  gem 'darjeelink', git: 'https://github.com/38degrees/darjeelink.git',
                    branch: 'darjeelink-v0.14.6-upgrade'
  ```
- Update the `Gemfile.lock` in the `portkey-app` repo by running `bundle install` and commit then push the changes.
- Deploy your branch of the portkey-app to the staging environment and test the changes.

NB: When you have followed the production release steps below and created a GitHub release, you can then update the `Gemfile` in the `portkey-app` repo to point to the new release tag. 

### Releasing - Production

Once all necessary changes have made it in to master and you are ready to do a release you need to do these steps.

Note that if you are running in a vagrant VM or `docker-shell.sh` constainer, most of these steps can be done from the terminal session.

- Update `lib/darjeelink/version.rb` to the new version
- Run `bundle install` to pick up the change in Gemfile.lock
- Commit the changes to `lib/darjeelink/version.rb` and `Gemfile.lock`, and push them to GitHub
- Go to `https://github.com/38degrees/darjeelink/releases` and create a release tag in GitHub
- Run `gem build darjeelink.gemspec` this will output a file `darjeelink-X.X.X.gem` the version should match what version.rb and github.
- Run `gem push darjeelink-X.X.X.gem`

## TODOs

We have a few TODOs in the project. Please grep for TODO in the codebase to see them, and consider picking one up during maintainance.

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
