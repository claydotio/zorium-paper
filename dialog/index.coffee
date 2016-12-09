z = require 'zorium'
_isEmpty = require 'lodash/isEmpty'
_map = require 'lodash/map'

if window?
  require './index.styl'

module.exports = class Dialog
  render: ({title, $content, actions, onleave}) ->
    actions ?= []
    $content ?= ''
    onleave ?= (-> null)

    z '.zp-dialog',
      z '.backdrop', onclick: onleave
      z '.dialog',
        z '.info',
          if title
            z '.title', title
          z '.content', $content
        unless _isEmpty actions
          z '.actions',
            _map actions, '$el'
