// Generated by CoffeeScript 1.7.1
(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  this.KeyPatternLogger = (function() {
    KeyPatternLogger.prototype._keys = {
      8: "backspace",
      9: "tab",
      12: "clear",
      13: "enter",
      16: "⇧",
      17: "⌃",
      18: "⌥",
      27: "esc",
      32: "space",
      37: "left",
      38: "up",
      39: "right",
      40: "down",
      46: "delete",
      36: "home",
      35: "end",
      33: "pageup",
      34: "pagedown",
      91: "⌘",
      93: "⌘"
    };

    function KeyPatternLogger(options) {
      if (options == null) {
        options = {};
      }
      this.setOptions(options);
      this.keysLogged = [];
      this.start();
    }

    KeyPatternLogger.prototype.setOptions = function(options) {
      var key, value, _results;
      if (options == null) {
        options = {};
      }
      if ("pattern" in options) {
        this.pattern = (function() {
          var _i, _len, _ref, _results;
          _ref = options.pattern;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            key = _ref[_i];
            _results.push(key.toLowerCase());
          }
          return _results;
        })();
        delete options.pattern;
      }
      _results = [];
      for (key in options) {
        value = options[key];
        _results.push(this[key] = value);
      }
      return _results;
    };

    KeyPatternLogger.prototype.start = function() {
      return document.body.addEventListener("keyup", this, true);
    };

    KeyPatternLogger.prototype.stop = function() {
      return document.body.removeEventListener("keyup", this, true);
    };

    KeyPatternLogger.prototype.handleEvent = function(e) {
      switch (e.type) {
        case "keyup":
          return this.handleKeyup(this._parseKey(e));
      }
    };

    KeyPatternLogger.prototype.handleKeyup = function(keyPressed) {
      var index, key, matches, _i, _len, _ref;
      this.keysLogged.push(keyPressed);
      if (__indexOf.call(this.pattern, keyPressed) >= 0) {
        matches = true;
        _ref = this.pattern;
        for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
          key = _ref[index];
          if (this.keysLogged[index] !== key) {
            matches = false;
            if (this.keysLogged[index]) {
              this.keysLogged = [];
              if (keyPressed === this.pattern[0]) {
                this.keysLogged.push(keyPressed);
              }
            }
            break;
          }
        }
        if (matches) {
          if (typeof this.callback === "function") {
            this.callback();
          }
          return this.keysLogged = [];
        }
      } else {
        return this.keysLogged = [];
      }
    };

    KeyPatternLogger.prototype.destroy = function() {
      return this.stop();
    };

    KeyPatternLogger.prototype._parseKey = function(e) {
      var key, keyCode;
      if (e.key) {
        keyCode = e.key.toLowerCase();
      } else if (e.keyIdentifier) {
        keyCode = parseInt(e.keyIdentifier.replace("U+", "0x"), 16);
        keyCode = String.fromCharCode(keyCode).toLowerCase();
      }
      key = e.key ? keyCode : this._keys[e.keyCode] || keyCode;
      if (e.shiftKey && key.indexOf("shift") === -1) {
        key = "shift+".concat(key);
      }
      if (e.altKey && key.indexOf("alt") === -1) {
        key = "alt+".concat(key);
      }
      if (e.ctrlKey && key.indexOf("control") === -1) {
        key = "control+".concat(key);
      }
      if (e.metaKey && key.indexOf("meta") === -1) {
        key = "meta+".concat(key);
      }
      return key;
    };

    return KeyPatternLogger;

  })();

}).call(this);
