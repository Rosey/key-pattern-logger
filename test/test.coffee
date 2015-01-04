chai = require "chai"
spies = require "chai-spies"
jsdom = require "mocha-jsdom"
kpl = require "../key_pattern_logger.coffee"

chai.should()
chai.use(spies)

describe("KeyPatternLogger", ->
  jsdom()

  before ->
    @keyPatternLogger = new kpl.KeyPatternLogger({
      pattern: ["a", "b", "c"]
    })
  
  describe("Pattern Matching", ->
    beforeEach ->
      @spy = chai.spy()
      @keyPatternLogger.setOptions({
        callback: @spy
      })

    it("calls callback when all keys in pattern are hit in the correct order", ->
      @keyPatternLogger.handleKeyup("a")
      @keyPatternLogger.handleKeyup("b")
      @keyPatternLogger.handleKeyup("c")
      @spy.should.have.been.called.exactly(1)
    )

    it("calls callback when wrong keys are hit before the pattern", ->
      @keyPatternLogger.handleKeyup("x")
      @keyPatternLogger.handleKeyup("a")
      @keyPatternLogger.handleKeyup("a")
      @keyPatternLogger.handleKeyup("a")
      @keyPatternLogger.handleKeyup("b")
      @keyPatternLogger.handleKeyup("c")
      @spy.should.have.been.called.exactly(1)
    )

    it("calls callback when wrong keys are hit after the pattern", ->
      @keyPatternLogger.handleKeyup("a")
      @keyPatternLogger.handleKeyup("b")
      @keyPatternLogger.handleKeyup("c")
      @keyPatternLogger.handleKeyup("x")
      @keyPatternLogger.handleKeyup("a")
      @keyPatternLogger.handleKeyup("a")
      @spy.should.have.been.called.exactly(1)
    )

    it("calls callback each time the pattern is hit", ->
      @keyPatternLogger.handleKeyup("a")
      @keyPatternLogger.handleKeyup("b")
      @keyPatternLogger.handleKeyup("c")
      @keyPatternLogger.handleKeyup("a")
      @keyPatternLogger.handleKeyup("b")
      @keyPatternLogger.handleKeyup("c")
      @spy.should.have.been.called.exactly(2)
    )

    it("doesn't call callback when other keys are hit", ->
      @keyPatternLogger.handleKeyup("5")
      @keyPatternLogger.handleKeyup("3")
      @keyPatternLogger.handleKeyup("s")
      @spy.should.not.have.been.called()
    )

    it("doesn't call callback when the right keys are hit but in the wrong order", ->
      @keyPatternLogger.handleKeyup("c")
      @keyPatternLogger.handleKeyup("a")
      @keyPatternLogger.handleKeyup("b")
      @spy.should.not.have.been.called()
    )

    it("doesn't call callback if one incorrect key is in middle of th pattern", ->
      @keyPatternLogger.handleKeyup("a")
      @keyPatternLogger.handleKeyup("1")
      @keyPatternLogger.handleKeyup("b")
      @keyPatternLogger.handleKeyup("c")
      @spy.should.not.have.been.called()
    )
  )
)
