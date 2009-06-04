require 'singleton'

# Module RCron
module RCron
  
  module DSL
    def rcron(&block)
      RCron::Suite.instance.instance_eval &block
    end
  end
  
  # 
  class Suite
    include Singleton
    attr_accessor :jobs
    def initialize
      @jobs = []
    end
    def job(schedule, &task)
      jobs << ::RCron::Job.new(schedule, task)
    end
    def run
      @thread = Thread.new do
        while true
          begin
            puts 'interval...'
            @jobs.each do |job|
              p job
            end
          rescue => e
          end
          sleep 1
        end
      end
      @thread.join
    end
  end
  
  # 
  class Job
    attr_accessor :schedule, :task
    def initialize(schedule,task)
      self.schedule, self.task = schedule, task
    end
  end
  
end

include RCron::DSL
