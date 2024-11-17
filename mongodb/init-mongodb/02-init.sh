#!/bin/bash

echo "########### Loading data to Mongo DB ###########"
mongoimport --jsonArray --db customer --collection customer_transaction             --file /tmp/data/data.json
mongoimport --jsonArray --db customer --collection customer_transaction_duplicate   --file /tmp/data/data.json
mongoimport --jsonArray --db customer --collection customer_transaction_1           --file /tmp/data/data_10.json
mongoimport --jsonArray --db customer --collection customer_transaction_1_duplicate --file /tmp/data/data_10.json
mongoimport --jsonArray --db customer --collection customer_transaction_2           --file /tmp/data/data_10_20.json
