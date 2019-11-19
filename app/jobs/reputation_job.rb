class ReputationJob < ApplicationJob
  queue_as :default

  # there are wrappers "perform_now & later" on 'perform' method when job called
  def perform(object)
    Services::Reputation.calculate(object)
  end
end
