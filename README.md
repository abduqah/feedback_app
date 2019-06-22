# Feedback/State Creation API

## Table of contents:

* [Description](./README.md#description)
  * [Task](./README.md#task)
* [Setup](./README.md#setup)
* [Running the app](./README.md#running-the-app)
* [Running the tests](./README.md#running-the-tests)

## Description

Simple feedbacks Post and retrieval rails APIs application

## Task

Assuming you're working on feedback system with a company token, when the company use the system it reports feedback using this token, this way we know which feedback belongs to company.
Each feedback is given a feedback number ( other than the database id ), this number starts from 1 for each company token.

We need you to create an API to simulate this behavior

Create two models:
- feedback:
  We want to track these fields
	- company token ( the unique identifier for the company )
	- number ( unique number per company, this is not the database primary key )
	- priority ( 'minor', 'major', 'critical' )

- state:  
  Defines the state of the mobile while reporting the feedback, we want to track these fields
	- device ( The device name, ex: 'iPhone 5' )
	- os ( the name of the operating system of the phone )
	- memory ( Number in mb, ex: '1024' )
	- storage ( Number in mb, example '20480' )

- Create an endpoint `POST /feedbacks` that is used to report a feedback, the phone will send all the params in one request ( for the feedback and the state, you design the format ), you will use the params to create a new feedback and a new state, and return the feedback number in a JSON  `{ number: 1 }`.

- Create an endpoint `GET /feedbacks/[number]`, which fetches the feedback using the number and company token, and returns the attributes in a JSON. Adjust the database indices to minimize the response time.

- Create an endpoint `GET /feedbacks/count`, that receives a company token and replies with the total number of feedbacks that belong to that company, this endpoint is performing slowly, so we want you to implement a method of in memory caching to speed up the response time.

- Create an endpoint `GET /feedbacks`, that receives a company token and replies with the feedbacks, as we have a hug database we need to get the from Elastcisearch instead of direct from the database.

- The `POST /feedbacks ` endpoint's load usually has too many spikes. To workaround this, the endpoint doesn't need to write to the DB directly, but instead it should relay the insertion to a background job, but it should still return the correct feedback number (from cache). You should choose a background processing system that could handle the highest throughput. (Preferably Sidekiq)

- Use rails v5+, ruby 2.3+, MySQL, Elastcisearch, Sidekiq and any extra tools/gems you need to optimize your API.

Extra:
- Handle bad requests with an error message and a non success response code, the JSON will contain `{ error: 'the error message' }`
- Write specs to test the endpoints, add happy and unhappy scenarios.

## Setup

1. Make sure you have Ruby 2.3.8, MySQL and rails v 5.2.2 installed in your machine. check the following link for help [gorails site](https://gorails.com/setup/ubuntu/18.04).

2. Make sure you install Redis, and Elastcisearch on your machine. 

		- redis on Fedora: sudo dnf install redis-server
		- redis on Ubuntu: sudo apt install redis-server

	.check the following links on how to install Elasticsearch on Fedora or Ubuntu.

		Fedora: https://computingforgeeks.com/how-to-install-elasticsearch-6-x-on-fedora-29-fedora-28/
		Ubuntu: https://tecadmin.net/setup-elasticsearch-on-ubuntu/

3. Install the [bundler gem](http://bundler.io/) by running:

    ```gem install bundler```

4. Clone this repo:

    ```git clone https://github.com/abduqah/feedback_app.git```

5. go to the app directory:

    ```cd feedback_app```

6. Install dependencies:

    ```bundle install```

7. Configure your database in config/database.yml

## Running the app

8. Create the database

    ```rails db:create db:migrate```

9. Run the Redis server

    ```redis-server```

10. Run the Elasticsearch server

    ``` sudo systemctl start elasticsearch.service ```

11. Make sure Elasticsearch server is running properly

    ```curl -XGET '0.0.0.0:9200/'  ```

12. Run the Sidekiq server

    ```sidekiq```

13. Start the server

    ```rails s```

14. To create a new feedback and associated state:

    ```post a json like '{"company_token":"new_token","feedback":{"priority": 2, "state_attributes":{"device": "OnePlus 6T","os":"Android 9","memory": 8192,"storage": 129024}}}' to 0.0.0.0:3000/api/v1/feedbacks```

		- you can use postman for API easy accessing, download it from https://www.getpostman.com/downloads/

15. To get back a specific feedback

    ```0.0.0.0:3000/api/v1/feedbacks/:feedback_number?company_token=:company_token```

16. To get back the feedback count by company_token token

    ```0.0.0.0:3000/api/v1/feedbacks/count?company_token=:company_token```

17. Search feedbacks using a company_token

    ```0.0.0.0:3000/api/v1/feedbacks?company_token=:company_token```

## Running the tests

0. Run tests

    ```rspec```
