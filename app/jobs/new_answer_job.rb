class NewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::NewAnswerNotify.new.send_update(answer)
  end
end
