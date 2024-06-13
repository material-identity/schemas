FROM node:22

WORKDIR /usr/src/app

RUN wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb   && \
    dpkg -i jdk-21_linux-x64_bin.deb

RUN apt-get update && \
    apt-get install -y fop && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y pdftk-java && \
    rm -rf /var/lib/apt/lists/*

COPY package*.json ./

RUN npm install

COPY . .

RUN npm install -g typescript

RUN tsc 

RUN chmod +x ./dist/main.js

CMD [ "node", "./dist/main.js" ]
