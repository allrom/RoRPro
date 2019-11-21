class NewAnswerJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    Services::NewAnswerNotify.new.send_update(answer)
  end
end
