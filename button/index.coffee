z = require 'zorium'
_ = require 'lodash'

colors = require '../colors.json'
Ripple = require '../ripple'

if window?
  require './index.styl'

getBackgroundColor = ({color, isRaised, isActive, isHovered, isDisabled}) ->
  if color and isRaised and not isDisabled
    if isActive
      colors["$#{color}700"]
    else if isHovered
      colors["$#{color}600"]
    else
      colors["$#{color}500"]

getTextColor = ({color, isRaised, isDisabled}) ->
  if not isDisabled
    if color and isRaised
      colors["$#{color}500Text"]
    else if color
      colors["$#{color}500"]

getRippleColor = ({color, isRaised}) ->
  if color and isRaised
    colors["$#{color}500Text"]
  else if color
    colors["$#{color}500"]

module.exports = class Button
  constructor: ({onclick, type, isDisabled, isRaised, color, $children} = {}) ->
    # TODO: remove $children constructor support
    if $children?
      console.log '"$children" in zorium-paper/button constructor is deprecated'
    onclick ?= -> null
    type ?= 'button'

    @$ripple = new Ripple({
      color: getRippleColor {color, isRaised}
    })

    @state = z.state {
      onclick
      type
      isDisabled
      isRaised
      color
      $children
      isHovered: false
      isActive: false
    }

  render: ({$children}) =>
    # TODO: remove $children constructor support
    $children ?= @state.getValue().$children
    {onclick, type, isDisabled, isRaised, color,
      isHovered, isActive} = @state.getValue()
    unless _.isArray $children
      $children = [$children]

    backgroundColor = getBackgroundColor {
      color
      isRaised
      isActive
      isHovered
      isDisabled
    }
    textColor = getTextColor {color, isRaised, isDisabled}

    z '.zp-button',
      className: z.classKebab {
        isDisabled
        isHovered
        isActive
        isRaised
      }
      ontouchstart: =>
        @state.set isActive: true
      ontouchend: =>
        @state.set isActive: false, isHovered: false
      onmouseover: =>
        @state.set isHovered: true
      onmouseout: =>
        @state.set isHovered: false
      onmouseup: =>
        @state.set isActive: false
      onclick: (e) =>
        @state.set isHovered: false
        onclick(e)
      onmousedown: =>
        @state.set isActive: true, isHovered: false
      z 'button.button',
        attributes:
          disabled: if isDisabled then true else undefined
          type: type
        style:
          background: backgroundColor
          color: textColor
        [@$ripple].concat $children
