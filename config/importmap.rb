# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "@rails/actioncable", to: "actioncable.esm.js"

pin "echarts", to: "https://cdn.jsdelivr.net/npm/echarts@5.5.0/dist/echarts.min.js"
pin "papaparse", to: "https://cdn.jsdelivr.net/npm/papaparse@5.4.1/+esm"

pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/channels", under: "channels"
pin_all_from "app/javascript/src", under: "src"
