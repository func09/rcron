require 'singleton'

module RCron
  
  class Suite
    include Singleton
    attr_accessor :jobs
    def initialize
      @jobs = []
    end
    def job(schedule, &task)
      jobs << ::RCron::Job.new(schedule, task)
    end
  end

  class Job
    attr_accessor :schedule, :task
    def initialize(schedule,task)
      self.schedule, self.task = schedule, task
    end
  end
  
end

def rcron(&block)
  RCron::Suite.instance.instance_eval &block
  # for debug
  p RCron::Suite.instance.jobs
end

# start DSL
rcron do
  job '* * * * *' do
    p 'job test *'
  end
  job '*/2 * * * *' do
    p 'job test */2'
  end
end

