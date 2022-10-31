# Rodrigo Alberto Solis Gonzalez
    
    This is the algorithm used to solve the LTV Full Stack Ruby challenge for the Jr. Full-Stack Ruby Engineer position. 
    The process to solve this challenge started with an exhaustive research about Ruby on Rails. Once I got knowledge of 
    how Ruby on Rails works. I did a extensive research on the best algorithm to do this in order to generate the length 
    that was as low as possible in relation to the number of links that were already in the database. 
    Through this search, I found out that one of the popular techniques was to convert the "id" to a 62 code base.

# URL Shortener algorithm

    Base62 Encoding allows us to use the combination of characters and numbers which contains lower case between 
    ['a'...'z'], upper case ['A'...'Z'] or a digit ['0'...'9']. 
    
    Steps:

    I used the integer id stored in the database and conver the integer to a character string only if the integer is not nil. 
    Then I made a loop that runs only if the integer is positive. To get the string I made a divition using the Modulo Operator to 
    get the remainder of dividing the id by 62 and this result will be the specific index in 'CHARACTERS' set. 
    Once the code is generated I store it in the database.
     
    To redirect the user to the full url using the short url:

    When the user enters the short url the API will search the matching database record and return the full url. By doing this 
    now I do not need to write decoder method to convert the base62 code to decimal.

# Intial Setup

    docker-compose build
    docker-compose up mariadb
    # Once mariadb says it's ready for connections, you can use ctrl + c to stop it
    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml build

# To run migrations

    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml run short-app-rspec rails db:test:prepare

# To run the specs

    docker-compose -f docker-compose-test.yml run short-app-rspec

# Run the web server

    docker-compose up

# Adding a URL

    curl -X POST -d "full_url=https://google.com" http://localhost:3000/short_urls.json

# Getting the top 100

    curl localhost:3000

# Checking your short URL redirect

    curl -I localhost:3000/abc
