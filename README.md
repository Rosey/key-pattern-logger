Key Pattern Logger
==================

Simple tool that listens for keys to be hit in a certain order and calls a callback if the pattern matches.


### Basic Example

```javascript
keyPatternLogger = new KeyPatternLogger(
  {
    pattern: ["a", "b", "c"],
    callback: function() {
      console.log("It worked!");
    }
  }
)
```


### Constructor Arguments

Accepts hash of parameters, `pattern` and `callback`.

  - `pattern` is an array of keys, can be as many or as few as you like
  - `callback` is a method with code that you want to execute when the
    pattern occurs.

_Note: Modifier keys can also be checked for, e.g. `"⌘a"`_


If the pattern consists of multiple keys, e.g. ["a", "b", "c"] the user
needs to hit a, b, and c, in that order. If they hit any other key in-between,
it isn’t a match.

If you only want to listen for one key, e.g. `["a"]`, that’s totally
fine too. The callback will be called every single time someone hits the
`a` key.


### Stopping the KeyPatternLogger

If you want to stop the KeyPatternLogger from listening for matches,
you can call `keyPatternLogger.stop()` (and start it again with
`keyPatternLogger.start()`)
