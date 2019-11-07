FROM node:12.13

WORKDIR /usr/src/app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --no-cache --production
COPY . .

CMD [ "yarn", "start" ]

