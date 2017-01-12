z = require 'zorium'
Rx = require 'rx-lite'

paperColors = require '../colors.json'

if window?
  require './index.styl'

module.exports = class Textarea
  constructor: ({@value, @valueStreams, @error, @isFocused} = {}) ->
    @value ?= new Rx.BehaviorSubject ''
    @error ?= new Rx.BehaviorSubject null

    @isFocused ?= new Rx.BehaviorSubject false

    @state = z.state {
      isFocused: @isFocused
      value: @valueStreams?.switch() or @value
      error: @error
    }

  render: ({colors, hintText, type, isFloating, isDisabled, isDark}) =>
    {value, error, isFocused} = @state.getValue()

    colors ?= {
      c500: paperColors.$black
    }
    hintText ?= ''
    type ?= 'text'
    isFloating ?= false
    isDisabled ?= false

    z '.zp-textarea',
      className: z.classKebab {
        isDark
        isFloating
        hasValue: value isnt ''
        isFocused
        isDisabled
        isError: error?
      }
      z '.hint', {
        style:
          color: if isFocused and not error? \
                 then colors.c500 else null
      },
        hintText
      z 'textarea.textarea',
        attributes:
          disabled: if isDisabled then true else undefined
          type: type
        value: value
        oninput: z.ev (e, $$el) =>
          if @valueStreams
            @valueStreams.onNext Rx.Observable.just $$el.value
          else
            @value.onNext $$el.value
          @value?.onNext $$el.value
        onfocus: z.ev (e, $$el) =>
          @isFocused.onNext true
        onblur: z.ev (e, $$el) =>
          @isFocused.onNext false
      z '.underline',
        style:
          backgroundColor: if isFocused and not error? \
                           then colors.c500 else null
      if error?
        z '.error', error
