# frozen_string_literal: true

Dir[File.absolute_path(File.join('.', 'promotions', '**', '*.rb'), __dir__)].each { |f| require f }
