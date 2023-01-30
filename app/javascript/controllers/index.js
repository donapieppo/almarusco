import { application } from "./application"

import DisposalSelectorController from "./disposal_selector_controller"
application.register("disposal-selector", DisposalSelectorController)

import DisposalTypeController from "./disposal_type_controller"
application.register("disposal-type", DisposalTypeController)

import Accordion from "./accordion"
application.register("accordion", Accordion)

import LegalizeController from "./legalize_controller"
application.register("legalize", LegalizeController)

import PickingController from "./picking_controller.js"
application.register("picking", PickingController)

import DsaAwesomplete from "./dsa_awesomplete.js"
application.register("dsa-awesomplete", DsaAwesomplete)

import { DmTest, TurboModalController } from "dm_unibo_common"
application.register("turbo-modal", TurboModalController)


