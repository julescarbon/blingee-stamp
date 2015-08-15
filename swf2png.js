#!/usr/bin/env node

var fs = require('fs')
var spawn = require('child_process').spawn
var exec = require('child_process').exec

function swf_extract_png(swf_filename, png_filename, png_id){
  var child = spawn('swfextract', [
    '-p', png_id,
    '-o', png_filename,
    swf_filename
  ])
}

var swf_parse_swftool_regex = /PNGs?: ID\(s\) (.*)\n/

function swf_parse_swftool_output(swf_filename, txt){
  var prefix = swf_filename.split('.')[0]
  var matches = txt.match(swf_parse_swftool_regex)
  if (!matches || matches.length < 2) {
    console.log('no pngs')
    return
  }
  var ids = matches[1].split(', ')
  for (var i = 0; i < ids.length; i++){
    var png_filename = prefix + '_' + i + '.png'
    swf_extract_png(swf_filename, png_filename, ids[i])
  }
}

function swf_extract_pngs(filename){
  var child = exec('swfextract ' + filename, 
    function(error, stdout, stderr){
      swf_parse_swftool_output(filename, stdout, stderr)
  })
}





var argv = process.argv.slice(2)

if (!argv.length){
  console.log('swf2png.js foo.swf')
  return
}

var filename = argv[0]

swf_extract_pngs(filename)

