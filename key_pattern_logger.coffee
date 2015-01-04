# Key Pattern Logger
# Calls a callback method if a specified pattern of keys are hit in the
# correct order.
#
# Usage:
#
# Basic -
# keyPatternLogger = new KeyPatternLogger({pattern: [], callback: function() {} })
#
# Accepts hash of parameters in constructer, `pattern` and `callback`.
# `pattern` is an array of keys, can be as many or as few as you like
# callback is a method with code that you want to execute when the
# pattern occurs.
#
# Modifier keys can also be checked for, e.g. "⌘a"
#
# If the pattern consists of multiple keys, e.g. ["a", "b", "c"] the user
# needs to hit a, b, and c, in that order. If they hit any other key in-between,
# it isn’t a match.
#
# If you want to stop the KeyPatternLogger from listening for matches,
# you can call `keyPatternLogger.stop()` (and start it again with
# `keyPatternLogger.start()`)

class @KeyPatternLogger
  # Keys without a visual representation
  _keys:
    8: "backspace"
    9: "tab"
    12: "clear"
    13: "enter"
    16: "shift"
    17: "control"
    18: "alt"
    27: "esc"
    32: "space"
    37: "left"
    38: "up"
    39: "right"
    40: "down"
    46: "delete"
    36: "home"
    35: "end"
    33: "pageup"
    34: "pagedown"
    91: "meta"
    93: "meta"

  constructor: (options = {}) ->
    # normalize upper and lowercase letters so that we don’t have to
    # worry about A not matching a, and vice-versa.
    @setOptions(options)
    @keysLogged = []
    @start()

  setOptions: (options = {}) ->
    if "pattern" of options
      @pattern = for key in options.pattern
        key.toLowerCase()
      delete options.pattern

    for key, value of options
      this[key] = value

  start: ->
    document.body.addEventListener("keyup", this, true)

  stop: ->
    document.body.removeEventListener("keyup", this, true)

  handleEvent: (e) ->
    switch e.type
      when "keyup"
        @handleKeyup(@_parseKey(e))

  handleKeyup: (keyPressed) ->
    @keysLogged.push(keyPressed)
    if keyPressed in @pattern
      matches = true
      for key, index in @pattern
        if @keysLogged[index] != key
          matches = false
          # If `@keysLogged[index]` has a value it means the pattern has been broken
          # and we should reset. If it does _not_ have a value, then we _don’t_ reset
          # because although it doesn’t match the pattern yet, it still has the
          # potential to with the next keyup.
          if @keysLogged[index]
            @keysLogged = []
            # If we broke the pattern but broke it using the first key of the pattern
            # Then we need to log that. Otherwise, if, for example, our pattern is
            # ["a", "b", "c"], ["a", "b"] followed by the correct ["a", "b", "c"]
            # won't match correctly
            if keyPressed == @pattern[0]
              @keysLogged.push keyPressed
          break

      if matches
        @callback?()
        @keysLogged = []

    else
      @keysLogged = []

  destroy: ->
    @stop()

  _parseKey: (e) ->
    if e.key # this is used in firefox and ie see https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent.key
      keyCode = e.key.toLowerCase()
    else if e.keyIdentifier # hacky, this is used in chrome & safari
      keyCode = parseInt(e.keyIdentifier.replace("U+", "0x"), 16)
      keyCode = String.fromCharCode(keyCode).toLowerCase()

    key = if e.key then keyCode else @_keys[e.keyCode] || keyCode # TODO e.keyCode is depreciated
    key = "shift+".concat(key) if e.shiftKey && key.indexOf("shift") == -1
    key = "alt+".concat(key) if e.altKey && key.indexOf("alt") == -1
    key = "control+".concat(key) if e.ctrlKey && key.indexOf("control") == -1
    key = "meta+".concat(key) if e.metaKey && key.indexOf("meta") == -1
    key
