// Import and register all your controllers from the importmap under controllers/*

import { application } from "./application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
//import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
//eagerLoadControllersFrom("controllers", application)

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)

import TurboModalController from "./turbo_modal_controller"
application.register("turbo-modal", TurboModalController)
import CerSelectorController from "./cer_selector_controller"
application.register("cer-selector", CerSelectorController)
import DisposalTypeController from "./disposal_type"
application.register("disposal-type", DisposalTypeController)

