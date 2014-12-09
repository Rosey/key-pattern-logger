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
    16: "⇧"
    17: "⌃"
    18: "⌥"
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
    91: "⌘"
    93: "⌘"

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

  handleKeyup: (key) ->
    @keysLogged.push(key)
    if key in @pattern
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
          break

      if matches
        @callback?()
        @keysLogged = []

    else
      @keysLogged = []

  destroy: ->
    @stop()

  _parseKey: (e) ->
    keyCode = parseInt(e.keyIdentifier.replace("U+", "0x"), 16)
    key = @_keys[e.keyCode] || String.fromCharCode(keyCode).toLowerCase()
    key = "⇧".concat(key) if e.shiftKey
    key = "⌥".concat(key) if e.altKey
    key = "⌃".concat(key) if e.ctrlKey
    key = "⌘".concat(key) if e.metaKey
    key
