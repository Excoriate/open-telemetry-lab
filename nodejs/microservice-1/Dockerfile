FROM node:12.19.0-alpine3.9 AS development

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install glob rimraf
RUN npm -g install @nestjs/cli

RUN npm install --only=development

COPY . .

# test
RUN echo "development stage" && \
    pwd && \
    ls -ltrah

RUN npm run build

FROM node:12.19.0-alpine3.9 as production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

# docker compose passed arguments
ARG PORT_ARG
ARG NAME_ARG
ARG DELAY_ARG
ARG JAEGER_PORT_ARG
ARG JAEGER_HOST_ARG
ARG IS_LOCAL_ARG

ENV PORT=${PORT_ARG}
ENV NAME=${NAME_ARG}
ENV DELAY=${DELAY_ARG}
ENV PORT=${PORT_ARG}
ENV JAEGER_PORT=${JAEGER_PORT_ARG}
ENV JAEGER_HOST=${JAEGER_HOST_ARG}
ENV IS_LOCAL=${IS_LOCAL_ARG}

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --only=production
# test
RUN echo "production stage" && \
    pwd && \
    ls -ltrah

COPY . .

COPY --from=development /usr/src/app/dist ./dist

CMD ["node", "dist/main"]
