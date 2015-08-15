var fs = require('fs')
var async = require('async')
var request = require('request')

var AESBase64 = require('./lib/aes')
var aes = new AESBase64 (128, 128)
var aes_key = "rAI1P8bpXoReutED8XOTT0lh26MWhWz87IH4t39LjJp3wxLkEHDKE2Er"

var tag_queue = async.queue(function(task, callback){
  fetch_tag(task.tag, task.page, function(page_count){
    if (page_count > 1) {
      for (var i = 2; i <= page_count; i++) {
        tag_queue.push({ tag: task.tag, page: i })
      }
    }
    callback()
  })
}, 2)

var swf_queue = async.queue(function(task, callback){
  fetch_swf(task, callback)
}, 4)

fs.mkdir('data', function(err){
  tag_queue.push({ tag: "cat", page: 1 })
})

function fetch_tag (tag, page, callback) {
  var page_count = 1
  
  console.log("fetch", tag, "page", page)

  request("http://blingee.com/stamp/embedded_list?query=" + encodeURIComponent(tag) + "&page=" + page, function(error, response, body){
    if (response.statusCode !== 200) {
      console.error('error fetching tag', tag, page)
      callback(0)
      return
    }
    var lines = body.split("\n")
    lines.forEach(function(line){
      if (page == 1 && line.indexOf("<title>") !== -1) {
        page_count = +line.split("Stamps [p. 1 of ")[1].split("]")[0]
      }
      else if (line.indexOf('addStampToBlingeeMaker') !== -1 && line.indexOf("href") !== -1) {
        swf_queue.push({ line: line, tag: tag, page: page })
      }
    })
    callback(page_count)
  })
}
function fetch_swf (task, callback) {
  var cipher = task.line.split("addStampToBlingeeMaker('")[1].split("')")[0]
  var xml = aes.decrypt(cipher, aes_key, "ECB").split('"')
  var id = +xml[1]
  var swf_url = xml[3]
  
  make_id_dir(id, function(dir){
    var dest = dir + "/" + id + ".swf"
    fs.stat(dest, function(err, exists){
      if (exists && exists.size) {
        return callback()
      }
      request(swf_url, callback).pipe(fs.createWriteStream(dest))
    })
  })
}
function make_id_dir (id, callback) {
  var id_mod = id % 997
  var id_dir = String(id_mod)
  if (id_mod < 10)  id_dir = "0" + id_dir
  if (id_mod < 100) id_dir = "0" + id_dir
  id_dir = 'data/' + id_dir
  fs.mkdir(id_dir, function(){
    callback(id_dir)
  })
}

