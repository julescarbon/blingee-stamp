
var async = require('async')

var stamp = require('./stamp')
var tag = require('./tag')

module.exports = async.queue(function(task, callback){
  if (task.stamp) {
    stamp.fetch(task, callback)
  }
  else if (task.type) {
    tag.fetch_type(task, callback)
  }
  else if (task.path) {
    tag.fetch_path(task, callback)
  }
}, 2)
