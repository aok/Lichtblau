# Lichtblau

Lichtblau is our entry to Reaktor Code Camp '11.

It is built with CoffeeScript, Node.js, Express and Vows.

## Installation

    brew install node
    curl http://npmjs.org/install.sh | sh
    npm install node-dev coffee-script express vows
    npm install connect@0.5.10

## Running

    cake watch
    cake server
    cake test

## Testing with curl

    curl -H "Content-Type: application/json" -d @spec/round0-challenge0-data.json  http://localhost:8000
