var request = require('request')
var fs = require('fs')

var AESBase64 = require('./lib/aes')
var aes = new AESBase64 (128, 128)
var aes_key = "rAI1P8bpXoReutED8XOTT0lh26MWhWz87IH4t39LjJp3wxLkEHDKE2Er"



fs.mkdir('data', function(err){
  fetch_tag("cat")
})

function fetch_tag (tag) {
  page_count = 1
  fetch_tag_page(tag, 1, function(body){
    var lines = body.split("\n")
    lines.forEach(function(line){
      if (line.indexOf("<title>") !== -1) {
        page_count = +line.split("Stamps [p. 1 of ")[1].split("]")[0]
      }
      else if (line.indexOf('addStampToBlingeeMaker') !== -1 && line.indexOf("href") !== -1) {
        fetch_swf(line, tag)
      }
    })
    if (page_count > 1) {
      // fetch next page
    }
  })
}
function fetch_tag_page (tag, page, callback) {
  request("http://blingee.com/stamp/embedded_list?query=" + encodeURIComponent(tag) + "&page=" + page, function(error, response, body){
    if (response.statusCode !== 200) {
      console.error('error fetching tag', tag, page)
      return
    }
    callback(body)
  })
}
function fetch_swf (line, tag) {
  var cipher = line.split("addStampToBlingeeMaker('")[1].split("')")[0]
  var xml = aes.decrypt(cipher, aes_key, "ECB").split('"')
  var id = +xml[1]
  var swf_url = xml[3]
  
  make_id_dir(id, function(dir){
    var dest = dir + "/" + id + ".swf"
    fs.exists(dest, function(exists){
      if (exists) return
      request(swf_url).pipe(fs.createWriteStream(dest))
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

