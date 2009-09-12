$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))

require 'rubygems'
require 'test/spec'

require "solid_state"

class Stateful
  include SolidState

  def helper
    14
  end

  def outer
    10
  end

  state :start do

    def add(a, b)
      a + b
    end

    def use_helper
      helper
    end
    
  end

  state :next do

    def add(a, b)
      a - b
    end

    # This method will never get called
    # because of #outer defined outside
    # of this state
    def outer
      20
    end

  end

  state :last do 

    def add(a, b)
      a * b
    end

  end
end 

class SubState < Stateful

  state :another do

    def add(a, b)
      a % b
    end

  end

  starting_state :another

end

context "SolidState" do

  before do
    @stateful = Stateful.new
  end

  context "Query and changing state" do

    specify "can get current state" do
      @stateful.current_state.should.be nil
      @stateful.change_state! :start
      @stateful.current_state.should.equal :start
    end

    specify "can change states" do
      @stateful.change_state! :next
      @stateful.current_state.should.equal :next
    end

    specify "errors out on invalid state choice" do
      should.raise SolidState::InvalidStateError do
        @stateful.change_state! :fail_state
      end

      @stateful.current_state.should.not.equal :fail_state
    end

    specify "can have a start state" do
      Stateful.starting_state :start
      Stateful.new.current_state.should.equal :start
    end

  end

  context "Per-state functionality" do

    specify "properly uses methods defined in the current state" do
      @stateful.change_state! :start
      @stateful.add(2, 4).should.equal 6

      @stateful.change_state! :next
      @stateful.add(2, 4).should.equal -2

      @stateful.change_state! :last
      @stateful.add(2, 4).should.equal 8
    end

    specify "states have access to methods defined outside of states" do
      @stateful.change_state! :start
      @stateful.use_helper.should.equal 14
      @stateful.helper.should.equal 14
    end

    specify "state's don't have to have the same methods defined across" do
      @stateful.change_state! :next
      should.raise NoMethodError do
        @stateful.use_helper
      end
      @stateful.helper.should.equal 14
    end

    specify "WARNING: helper methods named the same as state methods use helper methods" do
      @stateful.change_state! :next
      @stateful.outer.should.equal 10
    end

  end

  context "Subclassing" do

    specify "subclasses can use parent class states" do
      state = SubState.new
      state.current_state.should.equal :another
      state.add(5, 2).should.equal 1

      should.not.raise SolidState::InvalidStateError do
        state.change_state! :next
      end
    end

  end

end
