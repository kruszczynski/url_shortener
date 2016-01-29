require 'bundler'
Bundler.setup

require 'etcd'

Etcd.client(host: ENV['ETCD_PORT_2379_TCP_ADDR'], port: 2379)
  .set('/url_shortener/development/counter1', value: 80)
