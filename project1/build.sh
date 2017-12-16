#!/bin/bash

# In case you use the provided ParseJSON.java code for preprocessing the wikipedia dataset, 
# uncomment the following two commands to compile and execute your modified code in this script.
javac ParseJSON.java
java ParseJSON

# TASK 2A:
# Create and index the documents using the default standard analyzer
curl -XPOST 'localhost:9200/task2a/wikipage/_bulk?pretty' -H "Content-Type: application/json" --data-binary "@data/out.txt" 


# TASK 2B:
# Create and index with a whitespace analyzer
curl -XPUT "localhost:9200/task2b/?pretty" -H 'Content-Type: application/json' -d'
{
    "settings" : {
        "index" : {
            "analysis": {
                "analyzer": {
                    "analyzer": {
                        "type": "whitespace",
                        "tokenizer": "whitespace"
                    }
                }
            }
        }
    },

    "mappings" : {
        "task2b" : {
            "_all" : {"type" : "string", "index" : "analyzed", "analyzer" : "whitespace"}
        }
    }
}'

curl -XPOST 'localhost:9200/task2b/wikipage/_bulk?pretty' -H "Content-Type: application/json" --data-binary "@data/out.txt" 



# TASK 2C:
# Create and index with a custom analyzer as specified in Task 2C
curl -XPUT 'localhost:9200/task2c/?pretty' -H 'Content-Type: application/json' -d'
{
    "settings": {
        "analysis": {
            "filter": {
                "my_stopwords": {
                    "type":       "stop",
                    "stopwords":  "_english_"
                },
                "my_snow" : {
                    "type" : "snowball",
                    "language" : "English"
                }
            },
            "analyzer": {
                "my_analyzer": {
                    "type":         "custom",
                    "char_filter":  "html_strip",
                    "tokenizer":    "standard",
                    "filter":       [ "standard", "asciifolding", "lowercase", "my_stopwords", "my_snow" ]
                }
            }
        }
    },
    "mappings" : {
        "task2c" : {
            "_all" : {"type" : "string", "index" : "analyzed", "analyzer" : "my_analyzer"}
        }
    }
}'

curl -XPOST 'localhost:9200/task2c/wikipage/_bulk?pretty' -H "Content-Type: application/json" --data-binary "@data/out.txt" 



