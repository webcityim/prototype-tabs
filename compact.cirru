
{} (:package |app)
  :configs $ {} (:init-fn |app.main/main!) (:reload-fn |app.main/reload!)
    :modules $ [] |respo.calcit/ |lilac/ |memof/ |respo-ui.calcit/ |respo-markdown.calcit/ |reel.calcit/ |respo-feather.calcit/
    :version |0.0.1
  :files $ {}
    |app.comp.container $ {}
      :ns $ quote
        ns app.comp.container $ :require (respo-ui.core :as ui)
          respo.core :refer $ defcomp defeffect <> >> div button textarea span input create-element list->
          respo.comp.space :refer $ =<
          reel.comp.reel :refer $ comp-reel
          app.config :refer $ dev?
          respo-ui.core :refer $ hsl
          feather.core :refer $ comp-icon comp-i
      :defs $ {}
        |comp-sidebar $ quote
          defcomp comp-sidebar () $ div
            {} $ :style
              merge ui/center $ {}
                :background-color $ hsl 0 0 90 0.8
                :width 40
                :box-shadow $ str "\"-1px 0 3px " (hsl 0 0 0 0.3)
                :position :fixed
                :right 0
                :top 0
                :height "\"100%"
            comp-i :user 20 $ hsl 0 0 0
            comp-i :bookmark 20 $ hsl 0 0 0
            comp-i :bluetooth 20 $ hsl 0 0 0
            comp-i :at-sign 20 $ hsl 0 0 0
            comp-i :codepen 20 $ hsl 0 0 0
            comp-i :crop 20 $ hsl 0 0 0
            comp-i :inbox 20 $ hsl 0 0 0
            comp-i :lock 20 $ hsl 0 0 0
            comp-i :layout 20 $ hsl 0 0 0
        |comp-container $ quote
          defcomp comp-container (reel)
            let
                store $ :store reel
                states $ :states store
                cursor $ either (:cursor states) ([])
                state $ either (:data states)
                  {} $ :content "\""
              div
                {} $ :style
                  merge ui/global ui/fullscreen ui/row $ {} (:background-image "\"url(https://h2.gifposter.com/bingImages/Mobula_EN-US7757384682_1920x1080.jpg)") (:user-select :none)
                list->
                  {} $ :style
                    merge ui/expand ui/row $ {} (:padding "\"8px")
                  -> (:tabs store)
                    map $ fn (x)
                      [] (:url x) (comp-tab x)
                    concat $ []
                      [] "\"__start" $ comp-start (>> states :start)
                      [] "\"__space" $ =< 400 nil
                comp-sidebar
                when dev? $ comp-reel (>> states :reel) reel ({})
        |comp-tab $ quote
          defcomp comp-tab (x)
            div
              {} $ :style (merge ui/column style-card)
              div
                {} $ :style
                  merge ui/row-parted $ {} (:padding "\"0 8px")
                    :background-color $ hsl 0 0 96
                    :border-bottom $ str "\"1px solid " (hsl 0 0 90)
                <> $ :title x
                comp-icon :x
                  {} (:font-size 14)
                    :color $ hsl 340 80 50
                    :cursor :pointer
                  fn (e d!)
                    d! :close $ :id x
              div
                {} $ :style ui/expand
                comp-frame $ :url x
        |links $ quote
          def links $ []
            {} (:title "\"知乎") (:url "\"http://quamolit.org")
            {} (:title "\"新浪") (:url "\"http://topix.im")
            {} (:title "\"淘宝") (:url "\"http://fp-china.org")
        |comp-frame $ quote
          defcomp comp-frame (url)
            create-element "\"iframe" $ {}
              :src $ if
                or (.starts-with? url "\"http://") (.starts-with? url "\"https://")
                , url (str "\"https://so.com/s?q=" url)
              :width "\"100%"
              :height "\"100%"
              :style $ {} (:border :none)
        |comp-start $ quote
          defcomp comp-start (states)
            let
                cursor $ :cursor states
                state $ or (:data states)
                  {} $ :draft "\""
              div
                {} $ :style
                  merge ui/center $ {}
                    :background-color $ hsl 0 0 100 0
                    :width 400
                    :padding "\"0 16px"
                div
                  {} $ :style
                    merge ui/column $ {} (:width "\"100%")
                  =< nil 16
                  input $ {}
                    :style $ merge ui/input
                    :placeholder "\"keyword or url"
                    :value $ :draft state
                    :on-input $ fn (e d!)
                      d! cursor $ assoc state :draft (-> e :event .-target .-value)
                    :on-keydown $ fn (e d!)
                      if
                        = 13 $ -> e :event .-keyCode
                        do
                          d! :open $ :draft state
                          d! cursor $ assoc state :draft "\""
                  =< nil 16
                  div
                    {} $ :style ui/row-parted
                    span nil
                    button $ {} (:style ui/button) (:inner-text "\"Search")
                      :on-click $ fn (e d!)
                        d! :open $ :draft state
                        d! cursor $ assoc state :draft "\""
                  =< 32 nil
                  div ({}) & $ -> links
                    map $ fn (link)
                      div
                        {}
                          :style $ merge ui/center
                            {} (:background-color :white) (:display :inline-flex) (:width 80) (:height 48) (:margin "\"0 8px 8px 0") (:font-size 20)
                          :on-click $ fn (e d!)
                            d! :open $ :url link
                        <> $ :title link
        |style-card $ quote
          def style-card $ {} (:background-color :white) (:width 480)
            :box-shadow $ str "\"1px 1px 4px " (hsl 0 0 0 0.3)
    |app.schema $ {}
      :ns $ quote (ns app.schema)
      :defs $ {}
        |tab $ quote
          def tab $ {} (:id nil) (:url nil) (:title nil)
        |store $ quote
          def store $ {}
            :states $ {}
              :cursor $ []
            :tabs $ do tab ([])
    |app.updater $ {}
      :ns $ quote
        ns app.updater $ :require
          respo.cursor :refer $ update-states
          app.schema :as schema
      :defs $ {}
        |updater $ quote
          defn updater (store op data op-id op-time)
            case op
              :states $ update-states store data
              :open $ update store :tabs
                fn (tabs)
                  conj tabs $ assoc schema/tab :id op-id :url data :title data
              :close $ update store :tabs
                fn (tabs)
                  -> tabs $ filter
                    fn (x)
                      not= (:id x) data
              :hydrate-storage data
              op store
    |app.main $ {}
      :ns $ quote
        ns app.main $ :require
          respo.core :refer $ render! clear-cache!
          app.comp.container :refer $ comp-container
          app.updater :refer $ updater
          app.schema :as schema
          reel.util :refer $ listen-devtools!
          reel.core :refer $ reel-updater refresh-reel
          reel.schema :as reel-schema
          app.config :as config
          "\"./calcit.build-errors" :default build-errors
          "\"bottom-tip" :default hud!
      :defs $ {}
        |render-app! $ quote
          defn render-app! () $ render! mount-target (comp-container @*reel) dispatch!
        |persist-storage! $ quote
          defn persist-storage! () $ .!setItem js/localStorage (:storage-key config/site)
            format-cirru-edn $ :store @*reel
        |mount-target $ quote
          def mount-target $ .!querySelector js/document |.app
        |*reel $ quote
          defatom *reel $ -> reel-schema/reel (assoc :base schema/store) (assoc :store schema/store)
        |main! $ quote
          defn main! ()
            println "\"Running mode:" $ if config/dev? "\"dev" "\"release"
            render-app!
            add-watch *reel :changes $ fn (reel prev) (render-app!)
            listen-devtools! |k dispatch!
            ; .!addEventListener js/window |beforeunload $ fn (event) (persist-storage!)
            ; repeat! 60 persist-storage!
            ; let
                raw $ .!getItem js/localStorage (:storage-key config/site)
              when (some? raw)
                dispatch! :hydrate-storage $ parse-cirru-edn raw
            println "|App started."
        |dispatch! $ quote
          defn dispatch! (op op-data)
            when
              and config/dev? $ not= op :states
              println "\"Dispatch:" op op-data
            reset! *reel $ reel-updater updater @*reel op op-data
        |reload! $ quote
          defn reload! () $ if (nil? build-errors)
            do (remove-watch *reel :changes) (clear-cache!)
              add-watch *reel :changes $ fn (reel prev) (render-app!)
              reset! *reel $ refresh-reel @*reel schema/store updater
              hud! "\"ok~" "\"Ok"
            hud! "\"error" build-errors
        |repeat! $ quote
          defn repeat! (duration cb)
            js/setTimeout
              fn () (cb)
                repeat! (* 1000 duration) cb
              * 1000 duration
    |app.config $ {}
      :ns $ quote (ns app.config)
      :defs $ {}
        |dev? $ quote
          def dev? $ = "\"dev" (get-env "\"mode")
        |site $ quote
          def site $ {} (:storage-key "\"prototype-tabs")
