require 'thread'

module FibUtils
  def self.fib(index)
    return index if index < 2
    return 1 if index == 2

    fib(index-2) + fib(index-1)
  end
end

# Main class
class App
  include FibUtils

  def initialize(run_count, num_to_find)
    @run_count = run_count
    @num_to_find = num_to_find
  end

  def run
    output_seperator
    puts "Running with single process"
    single_process
    output_seperator

    output_seperator
    puts "Running with threads"
    threads
    output_seperator

    output_seperator
    puts "Running with multiple processes"
    multi_process
    output_seperator
  end

  def single_process
    t1 = Time.now

    @run_count.times do
      test_case
    end

    t2 = Time.now
    time_taken = t2 -t1
    puts "#{__method__} Time taken: #{time_taken}"
  end

  def threads
    t1 = Time.now
    threads = []
    @run_count.times do
      t = Thread.new do
        test_case
      end
      threads << t
      t.run
    end

    threads.each do |t|
      t.join
    end

    t2 = Time.now
    time_taken = t2 -t1
    puts "#{__method__} Time taken: #{time_taken}"
  end

  def multi_process
    t1 = Time.now

    pids = []
    @run_count.times do
      pid = Process.fork do
        test_case
      end
      pids << pid
    end

    pids.each do |pid|
      Process.wait(pid)
    end

    t2 = Time.now
    time_taken = t2 -t1
    puts "#{__method__} Time taken: #{time_taken}"
  end

  def test_case
    FibUtils.fib(@num_to_find)
  end

  def output_seperator
    puts '-------------------------------'
  end
end

app = App.new(5, 35)
app.run