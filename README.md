# ZenFit

## Stack

* Ruby 2.5
* Ruby on Rails 5.1
* Docker 17.12.0-ce
* Postgresql

## Setup

Go to project and run
```
docker-compose build api   # you will be build the image
docker-compose up api      # run the api
```

## Specs

In the project home directory run
```
docker-compose run specs
```

> The file [postman.json](./postman.json) has to demonstrate how could you request the API.
> Import this file into your [Postman](https://www.getpostman.com/)

## Features

* ~Login and Sign up~
* ~CRUD of Zentimes~
* ~CRUD of Users~
* ~Permissions levels~
* ~Filter by dates from-to~
* ~Report on average zen hours spent per week~

