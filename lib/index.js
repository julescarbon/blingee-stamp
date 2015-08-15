var async = require('async')
var queue = require('./queue')

var blingee = module.exports = {
  go: function(){
    blingee.fetch_tags()
  },
  fetch_stamps: function(tag){
    queue.push({ stamp: tag, page: 1 })
  },
  fetch_tags: function(){
    queue.push({ type: "1032", page: 1 })
  }
}
