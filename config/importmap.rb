# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "roulette_modal", to: "roulette_modal.js" 
pin "google_maps_autocomplete", to: "google_maps_autocomplete.js"
pin "map_display", to: "map_display.js"