# Chattermill Code Challenge by Felipe Rodrigues

## Requirements

Recently we conducted several customer development interviews asking our potential clients how they analyze their customer feedback (let’s say their product reviews) and what kind of tool could be helpful for this. We realized that we need to build a very simple product that would allow them to track experience of their customers by giving them a dashboard that displays metrics based on their customer feedback.

To build an MVP we gathered a dataset based on public data which represents Google Play and Apple App Store reviews for various mobile apps popular in the UK. We applied our machine learning algorithms to this data to extract themes (which are various aspects of our client’s business like payments, delivery, product quality etc.) of each review and sentiments of those themes.

For our MVP we need to build a frontend with a single screen that would display couple charts and a backend that would serve API for our frontend.

You received `dataset.zip` which contains JSON representation of our dataset. Please use these files to populate data storage of your choice.

### Dashboard screen

Dashboard screen is the only screen of our frontend and it contains filters and charts. Here are the filters we need to implement:
● Filter by theme
● Filter by category
● Filter by phrase in a product review

In theme and category filters user can select one of the human-readable options from dropdown. Phrase filter is a text input where we can type an arbitrary substring of a comment field of a product review and thus filter reviews containing this substring. When we add or remove a filter our charts are getting updated.
We need to display 2 charts. One of them displays average sentiment with breakdown by category and another by theme. We recommend to use Highcharts JS to display these charts.

### Backend requirements

Besides API that your frontend needs you will need to implement one additional API endpoint that will be used by our clients to provide new reviews. This method creates a new review in your database and its request will contain a comment and themes with their sentiments. We will use this endpoint to populate your database with more reviews and test how your API performs for bigger datasets than the one we provided.

Feel free to choose any API protocol that feels right to you for this task as well as any database.

Keep in mind that one of the highest priorities for us is responsiveness of our charts because this is an analytical tool that will be used by our clients and they will be playing with different combinations of filters to find insights they need and they expect to see results right after updating the filter.

Another obvious requirement is a durability of data - our clients rely on Chattermill in understanding of how their customers feel and we think every single customer should be heard. For us it means we need to reduce the probability of losing any events in our system to the bare minimum.

## General structure

This application is composed of 4 components:

- **Dashboard** - A React app that presentes the charts and filters as requested.
- **Api Service** - An Elixir application using the Phoenix framework which provides the endpoints for the frontend. It assumes you have `Elixir 1.9.4` and `Erlang/OTP 22`.
- **Message Broker** - A RabbitMQ server to deal with the reviews creation
- **Relational Database** - A postgresql server to store the data.

### Api service as an umbrella app

The Phoenix application is an umbrella app under the `service` directory. It means the real applications are under the `service/apps` directory. There you will find two applications:

1. **`chattermill_review_service`** -> Domain application which contains the business logic and domain objects. You will also find here the review_amqp_worker, responsible for publishing and consuming the messages from rabbitMQ.
2. **`chattermill_review_service_web`** -> Holds the controller logic for the endpoints we provided. This app depends on the domain objects from the `chattermill_review_service`.

## Development

### Dashboard

The dashboard app is a simple react app. The api requests it makes will point to `http://localhost:4000` by default. You can change that in the `dashboard/.env.development` file. You can run the tests with the `yarn test` command.

You can start the app with the following commands:

```
yarn install

yarn start
```

It should open the app in your browser in `http://localhost:3000`.

### Api Service

You will need a RabbitMQ and a Postgres services running to run the applications.

The default configuration expects a postgres on `localhost:5432` and a RabbitMQ on `localhost:30003`. You can override that with env vars, as follow:

```
AMQP_HOST=localhost
AMQP_PORT=30003
AMQP_QUEUE=chattermill_review_dev
PG_HOST=localhost
PG_PORT=5432
```

The `AMQP_PORT` points to 30003 because I'm running rabbit from a kubernetes cluster which port range starts on 30000.

To run the tests you have to setup the database like this:

```
cd service

mix ecto.create

mix ecto.migrate

mix test
```

To start the application, you can load the seed data and start the phoenix server like that:

```
cd service # assuming you're not there already

mix run apps/chattermill_review_service/priv/repo/seeds.exs

mix phx.server
```

The `seeds.exs` will load the provided datasets. The `mix phx.server` will start the api endpoints in `http://localhost:4000`. I enabled the CORS to accept configurations from all hosts, just to simplify.

## Kubernetes build

I configured a kubernetes cluster for this application. It is not optimised for production, but is good enough to showcase some of my skills. You will need docker and kubectl up and running in your machine. I used the docker desktop kubernetes cluster for this challenge.

### Creating the docker images for dashboard and api service

To build the local docker images for the dashboard run the following commands:

```
cd dashboard

docker image build -t chattermill-dashboard:0.1 .
```

To build the local docker image for the api service run:

```
cd service

docker image build -t chattermill-api:0.1 .
```

After that you can start the pods and services in the kubernetes with the following command:

```
kubectl apply -k .
```

### K8s specs

Kubernetes is configuration starts with the `kustomization.yml` file. It just loads the yaml files for our 4 services.

```
resources:
  - dashboard/dashboard.yml
  - service/api.yml
  - rabbitmq.yml
  - postgresql.yml
```

There you can see the environment variables and the configured ports for our applications. I used pods directly instead of Deployments for simplicity, so it is not ready for production.

The ports exposed to the host machine are as follows:

- Dashboard -> 30001
- RabbitMQ Management UI -> 30002
- RabbitMQ amqp -> 30003
- Postgres -> 30004
- Api service -> 30005

## How to use it

To view the charts you just have to navigate to the dashboard and use the filters. The default address is `http://localhost:30001` when running it from kubernetes.

I created an endpoint to receive new reviews at `POST api/reviews`, which should receive a body json data like so:

```
{
    "review": {
        "comment": "Felipero is excellent keep it up",
        "themes": [
            {
                "theme_id": 6374,
                "sentiment": 1
            }
        ],
        "created_at": "2019-07-18T23:18:53.000Z",
        "id": 99457782
    }
}
```

## Design considerations and decisions

I tried to present the simplest architecture for and MVP. Obviously there are considerations to be made.

### Do we really needed a message broker for this challenge?

In real life I'd start without the AMQP server in the first version and add it after seeing need for it. I decide to add it here because I felt there is a hint to the text in the code challenge for it when you mention this:

> Another obvious requirement is a durability of data - our clients rely on Chattermill in understanding of how their customers feel and we think every single customer should be heard. For us it means we need to reduce the probability of losing any events in our system to the bare minimum.

I thought to myself: They are asking for a message broker.

### Is this app ready for huge loads?

Probably not. I recommend you send new reviews directly to the RabbitMQ server, so the phoenix app can consume it. You use the endpoint just as an example, but sending data through the http endpoint just to forward then to the amqp server won't help.

The biggest bottleneck I see here is in reading the averages. I created an cool query to read it directly from postgres, but it is filled with joins and aggregating the average directly in the query. This is far from ideal and won't support too many records.

### So, what's the next step in improving this?

My next step would be create a faster way to read data. Could be either a view in the postgres, triggered by every insert in the db or a indexing db like elasticsearch. If I had more time to work on it, that would be the next step.

### How much time did you spend on this challenge?

Too much. I dedicated around 5 days on this. First because I was missing a good reference implementation for myself, and it is good to have it, but mostly to research what would be good to show these days. For example how not to use an `ILIKE` query in postgres/ecto, when I came out with using `tsquery` contains operator.

There was also some back and forth in terms of what endpoints I would need, so if you look into the git history I started with an scaffolding and ended up deleting a bunch of code.

Anyway, I hope you like it.
