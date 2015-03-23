class TestService
  attr_reader :page,
              :per_page,
              :offset,
              :strong_badian

  OK = 200

  CHARACTERS = [
    {id: 1,  name: 'The King of Town', strong_badian: false},
    {id: 2,  name: 'Strong Mad',       strong_badian: true},
    {id: 3,  name: 'Marzipan',         strong_badian: false},
    {id: 4,  name: 'Homestar Runner',  strong_badian: false},
    {id: 5,  name: 'Coach Z',          strong_badian: false},
    {id: 6,  name: 'Pom Pom',          strong_badian: false},
    {id: 7,  name: 'Strong Sad',       strong_badian: false},
    {id: 8,  name: 'The Cheat',        strong_badian: true},
    {id: 9,  name: 'The Poopsmith',    strong_badian: false},
    {id: 10, name: 'Strong Bad',       strong_badian: true},
    {id: 11, name: 'Bubs',             strong_badian: false},
    {id: 12, name: 'Homsar',           strong_badian: false},
    {id: 13, name: 'Trogdor',          strong_badian: false},
    {id: 14, name: 'Tire',             strong_badian: true},
    {id: 15, name: 'Stop Sign',        strong_badian: true},
    {id: 16, name: 'Cinder Block',     strong_badian: true}
  ].freeze

  def initialize(env)
    Logger.append(env)

    @page          = env.params.fetch('page', 1).to_i
    @per_page      = env.params.fetch('per_page', 5).to_i
    @offset        = env.params.fetch('offset', 0).to_i
    @strong_badian = to_boolean(env.params['strong_badian'])
  end

  def characters
    collection = fetch

    [OK, headers(collection.count), paginate(collection).to_json]
  end

  private

  def headers(total_count)
    total_pages = (total_count.to_f / per_page).ceil
    next_page   = (page + 1) unless (page == total_pages)
    prev_page   = (page - 1) unless (page <= 1)

    {
      'X-Total'       => total_count,
      'X-Total-Pages' => total_pages,
      'X-Per-Page'    => per_page,
      'X-Page'        => page,
      'X-Next-Page'   => next_page,
      'X-Prev-Page'   => prev_page,
      'X-Offset'      => offset
    }
  end

  def fetch
    collection = CHARACTERS.dup

    unless strong_badian.nil?
      collection.select! { |member| member[:strong_badian] == strong_badian }
    end

    collection
  end

  def paginate(collection)
    from = (page - 1) * per_page
    to   = (page * per_page) - 1

    from += offset
    to   += offset

    collection.slice(from..to) || []
  end

  def to_boolean(value)
    return if value.nil?

    value == 'true'
  end

  class Logger
    class << self
      attr_reader :requests

      def append(env)
        @requests << env
      end

      def reset!
        @requests = []
      end
    end
  end

  module Helpers
    def reset_service!
      Logger.reset!
    end

    def request_count
      Logger.requests.count
    end
  end
end
