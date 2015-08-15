var fs = require('fs')
var async = require('async')
var request = require('request')

var queue = require('./queue')

module.exports = {
  fetch_type: function(task, callback){
    fetch_type(task.type, task.page, function(page_count){
      if (page_count > 1) {
        for (var i = 2; i <= page_count; i++) {
          queue.push({ type: task.type, page: i })
        }
      }
      callback()
    })
  },
  
  fetch_path: function(task, callback){
    fetch_path(task.path, callback)
  }
}

function fetch_type (type, page, callback) {
  var page_count = 1
  
  console.log("fetch type", tag, "page", page)

  request("http://blingee.com/stamp/list/page/" + page + "/type/" + type, function(error, response, body){
    if (response.statusCode !== 200) {
      console.error('error fetching tag', tag, page)
      callback(0)
      return
    }
    var lines = body.split("\n")
    lines.forEach(function(line){
      if (page == 1 && line.indexOf("<title>") !== -1) {
        page_count = +line.split("[p. 1 of ")[1].split("]")[0]
      }
      else if (line.indexOf('offset=') !== -1) {
        var path = line.split('"')[1]
        queue.push({ path: path })
      }
    })
    callback(page_count)
  })
}

function fetch_path (path, callback) {
  console.log("fetch path", path)

  request("http://blingee.com" + path, function(error, response, body){
    if (response.statusCode !== 200) {
      console.error('error fetching path', path)
      callback()
      return
    }
    var lines = body.split("\n")
    lines.forEach(function(line){
      if (line.indexOf('/stamp/tags/') !== -1) {
        var tag = line.split('title="')[1].split('"')[0]
        queue.push({ tag: tag, page: 1 })
      }
    })
    callback()
  })
}
