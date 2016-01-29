# Url Shortener

A simple API for url shortening

### API

Api will go here

### Development setup

1. Clone the repo
2. `docker-compose build`
3. `docker-compose run --rm web bundle install`
4. `docker-compose run --rm web bundle exec ruby etcd_setup.rb`
5. `docker-compose up`
6. The server awaits on port 3000

##### Potential issues

Make sure port 3000 is being forwarded from docker machine to your machine.

#####  About development setup
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
