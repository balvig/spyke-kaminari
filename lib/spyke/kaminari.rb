require 'active_support/core_ext'

module Spyke::Kaminari
  HEADERS = {
    total_count:  'X-Total',
    total_pages:  'X-Total-Pages',
    limit_value:  'X-Per-Page',
    current_page: 'X-Page',
    next_page:    'X-Next-Page',
    prev_page:    'X-Prev-Page',
    offset_value: 'X-Offset'
  }

  METADATA_KEY = :kaminari
end

require 'spyke/kaminari/header_parser'
require 'spyke/kaminari/relation'
require 'spyke/kaminari/scopes'
