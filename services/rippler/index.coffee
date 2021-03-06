z = require 'zorium'

if window?
  require './index.styl'

class Rippler
  ripple: ({$$el, color, mouseX, mouseY, isSmall}) ->
    isSmall ?= false
    isCenter = not mouseX? and not mouseY?

    {width, height, top, left} = $$el.getBoundingClientRect()

    $$rippleEffect = document.createElement 'div'
    $$rippleEffect.className =
      "zp-services-rippler #{isSmall and 'is-small' or ''}"
    $$rippleEffect.style.backgroundColor = color

    x = mouseX - left
    y = mouseY - top

    startWidth = 10
    startHeight = 10

    if isCenter
      $$rippleEffect.style.top = height / 2 + 'px'
      $$rippleEffect.style.left = width / 2 + 'px'
    else
      $$rippleEffect.style.top = y - height / 2 + startHeight * 2 + 'px'
      $$rippleEffect.style.left = x + 'px'

    $$el.appendChild $$rippleEffect

    if isSmall
      window.setTimeout ->
        $$rippleEffect.parentElement.removeChild $$rippleEffect
      , 900
    else
      window.setTimeout ->
        $$rippleEffect.parentElement.removeChild $$rippleEffect
      , 1400

module.exports = new Rippler()
