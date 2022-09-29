FROM node:17

WORKDIR /usr/src/app

COPY . .

RUN npm install
RUN npx run prisma migrate -y

EXPOSE 80
CMD [ "npm", "run", "dev" ]
