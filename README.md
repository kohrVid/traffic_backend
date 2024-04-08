# traffic_backend

This is the backend repo for the Traffic application

<!-- vim-markdown-toc GFM -->

* [About](#about)
* [Requirements](#requirements)
* [Development](#development)
  * [Tests](#tests)
  * [Swagger](#swagger)

<!-- vim-markdown-toc -->

## About

This application will act as an API for the Traffic application which will
essentially model visits to various pages for a given user. The frontend will
make requests to this application and then display its metrics.

## Requirements

* Ruby 3.3.0
* Rails 7.1.3
* Postgresql 16.1 (with collation [version
  2.39](https://dba.stackexchange.com/a/330184))


## Development

Create and migrate the development and tests databases:

    rails db:create
    rails db:migrate

Run the server:

    rails s

The server should the run on http:localhost:3000

### Tests

Unit tests can be run with rspec:

    rspec

or with their test descriptions:

    rspec -f documentation

### Swagger

rswag is used for Swagger documentation. It depends on a number of request
specs in the test suite. After changes are made to these tests the following
command will generate the documentation (`swagger/v1/swagger.yaml`):

    rails rswag:specs:swaggerize

The docs can then be found at http://localhost:3000/api-docs

This command will run the spec files with rspec and check expectations:

    SWAGGER_DRY_RUN=0 rails rswag:specs:swaggerize
