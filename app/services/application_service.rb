# frozen_string_literal: true

class ApplicationService
  def initialize(*args); end

  class << self
    def run(*args)
      new(*args).run
    end
  end
end
