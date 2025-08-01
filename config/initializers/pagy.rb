require 'pagy/extras/array'
require 'pagy/extras/metadata'

Pagy::DEFAULT[:items] = 20
Pagy::DEFAULT[:max_items] = 100
Pagy::DEFAULT[:page]  = 1
Pagy::DEFAULT[:overflow] = :empty_page