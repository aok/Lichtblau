fs = require 'fs'


exports.e0 = {
        "name":"lol",
        "timeout":6000,
        "contents":[
            {"id":"1","weight":[10,20,30],"value":40},
            {"id":"2","weight":[40,50,60],"value":100},
            {"id":"3","weight":[30,60,90],"value":200}
        ],
        "capacity":[99,10,1000]
    }
exports.e1 = {
    "name":"lol",
    "timeout":6000,
    "contents":[
        {"id":"1","weight":[10,20,30],"value":40},
        {"id":"2","weight":[40,50,60],"value":100},
        {"id":"3","weight":[30,60,90],"value":200}
    ],
    "capacity":[99,30,1000]
}
exports.e2 = {
    "name":"lol",
    "timeout":6000,
    "contents":[
        {"id":"1","weight":[10,20,30],"value":40},
        {"id":"2","weight":[40,50,60],"value":100},
        {"id":"3","weight":[30,60,90],"value":200}
    ],
    "capacity":[99,70,1000]
}
exports.round0 = () ->
    data = ''
    fs.readFile 'spec/round0-data.json', (err, contents) ->
        throw err if err
        console.log contents.length
        data = JSON.parse contents
    data