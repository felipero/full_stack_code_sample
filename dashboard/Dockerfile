FROM node:12.13

ENV CHATTERMILL_API_HOST http://chattermill-api-service:30005/api

WORKDIR /usr/src/app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --no-cache --production
COPY . .

RUN yarn build
RUN yarn global add serve

CMD [ "serve", "-s", "build" ]
