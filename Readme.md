# Url Shortener

A simple API for url shortening

### API

#### POST /shorten
The main endpoint of the app. Can be used be a developer to provide url
shortening.

##### Parameters:
- **url** - required, has to be prepended with http:// or https://
- **slug** - optional, a custom slug for shortened link. A generated one will be provided

##### Response:
- **url** the shortened url
- **target** the redirection target

##### Examples:
- `POST localhost:3000/shorten?url=https://www.twitter.com` will return
`{url: http://localhost:3000/Bxd, target: https://www.twitter.com}`
- `POST localhost:3000/shorten?url=https://www.twitter.com&slug=promotion`
will return `{url: http://localhost:3000/promotion, target:
https://www.twitter.com}`
- consecutive `POST
localhost:3000/shorten?url=https://www.facebook.com&slug=promotion` will return
status 422 and an error message

#### GET /:slug
The shortened url redirection endpoint.

##### Parameters:
- **slug** - required, a slug provided by /shorten

##### Response:
- a 301 redirect to target's url

### Development setup

1. Clone the repo
2. `docker-compose build`
3. `docker-compose run --rm web bundle install`
4. `docker-compose run --rm web bundle exec ruby etcd_setup.rb`
5. `docker-compose up`
6. The server awaits on port 3000

##### Potential issues

Make sure port 3000 is being forwarded from docker machine to your machine.

###  About development setup
I've been using docker for development for a while now so it was an obvious
choice.

The framework is [Sinatra](http://www.sinatrarb.com). It's fast, simple and
lightweight.

Data is stored in CouchDB. NoSQL's performance benefits and SQL abundance of
features not necessary for this task helped me make the choice.

Slugs are generated base on incremented number that is stored in an ETCD
cluster. My motivation was to make this system distributed-friendly and to keep slugs as short as possible. The other reason was getting to play with etcd.
`etcd_setup.rb` is a script that sets the initial number in the cluster.

### Specs and linters

1. `docker-compose run --rm web bundle exec rspec`
2. `docker-compose run --rm web bundle exec rubocop`
3. `docker-compose run --rm web bundle exec reek`
