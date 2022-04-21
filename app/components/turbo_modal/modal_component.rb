# frozen_string_literal: true
include Turbo::FramesHelper

class TurboModal::ModalComponent < ViewComponent::Base
  def initialize(title: "", hidden: false)
    @title = title
    @hidden = hidden
  end
end
