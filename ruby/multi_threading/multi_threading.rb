require 'csv'
require 'thread'
require 'net/http'

module FibUtils
  def fib(index)
    return index if index < 2
    return 1 if index == 2

    fib(index-2) + fib(index-1)
  end
end

module FileReadUtils
  def read_file()
    file_name = 'really_big_text_file.txt'
    output = File.read(file_name)
    puts "finished reading"
  end

  def read_csv()
    file_name = 'websites_to_visit.csv'
    CSV.read(file_name, headers: true)
  end
end

module HttpUtils
  include FileReadUtils

  def get_urls
    rows = read_csv
    rows.each do |row|
      response = Net::HTTP.get_response(URI(row[1]))
    end
  end
end

# Main class
class App
  include FibUtils
  include FileReadUtils
  include HttpUtils

  def initialize(run_count)
    @run_count = run_count
  end

  def run(*args)
    @args = *args
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
      test_case(@args)
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
        test_case(@args)
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
        test_case(@args)
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

  def test_case(args)
    #fib(args[0])
    #read_file
    get_urls
  end

  def output_seperator
    puts '-------------------------------'
  end
end

app = App.new(5)
#app.run(35) # FibUtils test
app.run()