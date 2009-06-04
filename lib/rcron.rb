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
              job.task.call if job.excutable?
            end
          rescue => e
            raise e
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
    def excutable?
      now = Time.now
      min, hour, day, month, wday = schedule.to_s.split(/\s/)
      if wday == '*' or wday.to_i == now.wday
        if month == '*' or month.to_i == now.month
          if day == '*' or day.to_i == now.day
            if hour == '*' or hour.to_i == now.hour
              if min == '*' or min.to_i == now.min
                return true
              end
            end
          end
        end
      end
      false
    end
  end
  
end

include RCron::DSL
