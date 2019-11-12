FROM node:12.13

ENV CHATTERMILL_API_HOST http://chattermill-api-service:4000/api

WORKDIR /usr/src/app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --no-cache --production
COPY . .

CMD [ "yarn", "start" ]
