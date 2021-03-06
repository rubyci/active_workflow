# TODO: move into runner?
class AgentCheckJob < ActiveJob::Base
  # Given an agent id, load the agent, call #check on it, and then save it with an updated `last_check_at` timestamp.
  # rubocop:disable Style/RescueStandardError
  def perform(agent_id)
    agent = Agent.find(agent_id)
    begin
      return if agent.unavailable?
      agent.check
      agent.last_check_at = Time.now
      agent.save!
    rescue => e
      agent.error "Exception during check. #{e.message}: #{e.backtrace.join("\n")}"
      raise
    end
  end
  # rubocop:enable Style/RescueStandardError
end
