fs = require 'fs'

exports.i1 = {"id":"1","weight":[1,1,1],"value":9}
exports.i2 = {"id":"2","weight":[1,1,1],"value":9}
exports.i3 = {"id":"3","weight":[1,1,1],"value":9}

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

exports.challenge = (round, challenge) ->
    getRound(round).challenges[challenge-1]

rounds = []
getRound = (idx) ->
    if not rounds[idx]
        path = fs.realpathSync('spec/data/round'+idx+'-data.json')
        rounds[idx] = JSON.parse(fs.readFileSync path)
    rounds[idx]
    