## Introduction


This repository is a customized version of [Interactive Brokers Gateway Docker](https://github.com/UnusualAlpha/ib-gateway-docker) , forked to meet specific requirements for educational materials.

## About Interactive Brokers Gateway Docker

Interactive Brokers Gateway Docker is a docker image that enables the running of the Interactive Brokers Gateway Application without any human interaction on a docker container.

The original project can be found on GitHub at [Interactive Brokers Gateway Docker](https://github.com/UnusualAlpha/ib-gateway-docker)


## About this Repository

This repository allows for the quick launch of TradingBoat using Docker. TradingBoat is a trading platform that receives alert messages via webhooks from TradingView and translates these into orders for Interactive Brokers. TradingBoat utilizes NGROK, Flask (TVWB), Redis, TBOT, and the IB Gateway as depicted in the images below.

Some of the environment variables used for the Docker configuration are inherited from the Interactive Brokers Gateway Docker project. Additionally, this repository introduces its own environment variables that control other components such as NGROK, Flask, Redis, and TBOT.

![image](https://github.com/bondjames12/ib-gateway-docker/assets/492840/cffb673e-1b70-4a26-8ff0-b3499a25218e)

 

## How to Run Tbot on TradingBoat Docker

### How to Build Docker

Clone the repository:

```
git clone https://github.com/PlusGenie/ib-gateway-docker
```


Copy dotenv into the root directory:

```
cd ib-gateway-docker
cp stable/tbot/dotenv .env
```

Open the dotenv file using a text editor and update the values of:

```
TWS_USERID: The account name used to log in to TWS / IB Gateway

TWS_PASSWORD: The password used to log in to TWS / IB Gateway

VNC_SERVER_PASSWORD

NGROK_AUTH: Authentication Token for NGROK as needed.
```


Once these steps are complete, you can run Tbot on Tradingboat Docker using the following command:

```
docker-compose up --build
```


After the docker starts, you can use two interfaces. Firstly, use VNC Viewer to access IB Gateway. Secondly, use the web application to track orders from TradingView to Interactive Brokers.


### How to Access IB Gateway through VNC server

Please use VNC Viewer to access the IB Gateway via the VNC server.

VNC Server: 127.0.0.1:5900

![image](https://github.com/bondjames12/ib-gateway-docker/assets/492840/50336b7f-3b57-4656-b6ce-5c52428da0da)

![image](https://github.com/bondjames12/ib-gateway-docker/assets/492840/da01ccf7-6bef-463b-831a-2057e4bbe930)



### How to Access Web App and Ngrok

After running docker-compose successfully, you can access the web application using a browser. The Dockerfile pulls the source of the web application from https://github.com/PlusGenie/tradingview-webhooks-bot . 

Then go to http://127.0.0.1:5000

![image](https://github.com/bondjames12/ib-gateway-docker/assets/492840/3cefc34a-ed84-4a1c-b7f4-d29be23a16eb)


### Demo 
Here's how to launch TBOT on TradingBoat using Docker in just 5 minutes. [Watch the demo on YouTube.](https://www.youtube.com/watch?v=lHgoKOgaiw4)

## Reference
* [Deploying TradingBoat Docker on a Public Cloud Computer Using AWS EC2](https://tbot.plusgenie.com/deploying-tradingboat-docker-on-a-public-cloud-computer-using-aws-ec2)
* [TBOT on TradingBoat: Unleash the Power of Automated Trading](https://tbot.plusgenie.com/unleash-the-power-of-automated-trading)
* [Brief Introduction to Trading Systems: Overcoming Challenges and Unlocking Potential #1](https://tbot.plusgenie.com/brief-introduction-to-trading-systems-overcoming-challenges-and-unlocking-potential)
* [Brief Introduction to Trading Systems: Overcoming Challenges and Unlocking Potential #2](https://tbot.plusgenie.com/brief-introduction-to-trading-systems-overcoming-challenges-and-unlocking-potential-2)
* [Brief Introduction to Trading Systems: Overcoming Challenges and Unlocking Potential #3](https://tbot.plusgenie.com/brief-introduction-to-trading-systems-overcoming-challenges-and-unlocking-potential-3)
* [A Quick Demo of Trading Robot](https://tbot.plusgenie.com/a-quick-demo-of-tbot-on-tradingboat)
---
* [Harnessing the Power of Redis for Efficient Trading Operations: A Detailed Look at Redis Pub/Sub and Redis Stream - Part 1](https://tbot.plusgenie.com/harnessing-the-power-of-redis-for-efficient-trading-operations-a-detailed-look-at-redis-pub-sub-and-redis-stream)

* [Harnessing the Power of Redis for Efficient Trading Operations: A Detailed Look at Redis Pub/Sub and Redis Stream- Part 2](https://tbot.plusgenie.com/harnessing-the-power-of-redis-for-efficient-trading-operations-a-detailed-look-at-redis-pub-sub-and-redis-stream-part-2/)

* [Optimizing Execution Time: Improving TradingView to Interactive Brokers Delay with AWS Cloud](https://tbot.plusgenie.com/optimizing-execution-time-improving-tradingview-to-interactive-brokers-delay-with-aws-cloud)

* [Decoding TradingView Alerts and Mastering ib_insync: A Comprehensive Guide](https://tbot.plusgenie.com/decoding-tradingview-alerts-and-mastering-ib_insync-a-comprehensive-guide)<br>
---
* [The extensive instructions and invaluable insights, enabling you to effectively leverage TBOT for your trading activities](https://www.udemy.com/course/simple-and-fast-trading-robot-setup-with-docker-tradingview/)
