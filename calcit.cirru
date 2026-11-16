
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |respo-ui.calcit/
      :type-slots $ {} $ :dispatch-op 'app.schema/Action
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (tabs draft)
            div
              {} $ :style $ merge ui/global ui/fullscreen ui/row
                {} (:background-color |#f4f4f4) (:align-items :flex-start)
              comp-start draft
              list->
                {} $ :style $ merge ui/row
                  {} $ :align-items :flex-start
                map-indexed
                  &set:to-list $ keys tabs
                  fn (idx url)
                    [] url $ comp-tab url
          :examples $ []
          :schema $ quote $ Fn (Map String String) String (-> respo.schema/Component)
        'comp-frame $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-frame (url)
            create-element :iframe $ {} (:src url) (:width |100%) (:height |100%)
              :style $ {} $ :border :none
          :examples $ []
          :schema $ quote $ Fn String (-> respo.schema/Component)
        'comp-start $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-start (draft)
            div
              {} $ :style $ merge ui/center
                {} (:width 320) (:height 480) (:margin 8) (:background-color :white) (:box-shadow "|0 2px 12px rgba(0,0,0,0.15)")
              div
                {} $ :style $ {} (:padding 16) (:font-size 20) (:font-family ui/font-fancy)
                <> "|Prototype Tabs"
              input $ {} (:value draft) (:placeholder |https://...)
                :style $ merge ui/input $ {} (:width |80%) (:margin-bottom 12)
                :on-input $ fn (e d!)
                  d! $ schema/Action :set-draft $ event-value e
              button $ {} (:inner-text |Open) (:style ui/button)
                :on-click $ fn (e d!)
                  d! $ schema/Action :add-tab draft
          :examples $ []
          :schema $ quote $ Fn String (-> respo.schema/Component)
        'comp-tab $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-tab (url)
            div
              {} $ :style $ merge ui/column
                {} (:width 360) (:height 480) (:margin 8) (:background-color :white) (:box-shadow "|0 2px 12px rgba(0,0,0,0.15)")
              div
                {} $ :style $ merge ui/row-parted
                  {} (:padding "|0 8px") (:height 40) (:border-bottom "|1px solid #eee")
                <> url
                span $ {} (:inner-text |x)
                  :style $ {} (:cursor :pointer) (:color :red)
                  :on-click $ fn (e d!)
                    d! $ schema/Action :close-tab url
              comp-frame url
          :examples $ []
          :schema $ quote $ Fn String (-> respo.schema/Component)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require (respo-ui.core :as ui)
            respo.core :refer $ defcomp defeffect div span button input <> list-> create-element event-value
            respo.comp.space :refer $ =<
            app.schema :as schema
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*draft $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *draft |
          :examples $ []
          :schema $ quote $ Ref String
        '*tabs $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *tabs ({})
          :examples $ []
          :schema $ quote $ Ref (Map String String)
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (action)
            match action
              (:add-tab url)
                do
                  reset! *tabs $ assoc @*tabs url url
                  reset! *draft |
              (:close-tab url)
                reset! *tabs $ dissoc @*tabs url
              (:set-draft text) (reset! *draft text)
            , &unit
          :examples $ []
          :schema $ quote $ Fn schema/Action (-> Unit) (:features :state)
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! () (println "|Prototype Tabs started.") (render-app!)
            add-watch! *tabs :changes $ fn (s p) (render-app!)
            add-watch! *draft :changes $ fn (s p) (render-app!)
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def mount-target
            .unwrap $ query-selector |.app
          :examples $ []
          :schema $ quote respo.dom/DomElement
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (nil? build-errors)
              do (remove-watch! *tabs :changes) (remove-watch! *draft :changes) (render-app!)
                add-watch! *tabs :changes $ fn (s p) (render-app!)
                add-watch! *draft :changes $ fn (s p) (render-app!)
              , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            render-with! mount-target
              fn () $ comp-container @*tabs @*draft
              , dispatch!
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            respo.core :refer $ render-with!
            respo.ffi.browser :refer $ query-selector
            app.comp.container :refer $ comp-container
            app.schema :as schema
            |./calcit.build-errors :default build-errors
    'app.schema $ %{} 'FileEntry
      :defs $ {} $ 'Action
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum Action (:add-tab String) (:close-tab String) (:set-draft String)
          :examples $ []
          :schema $ quote EnumDef
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
