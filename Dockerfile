FROM node:20

WORKDIR /app

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/FlowiseAI/Flowise.git .

RUN npm install

EXPOSE 3000

CMD ["npm", "run", "start"]
