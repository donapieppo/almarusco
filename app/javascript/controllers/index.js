import { application } from "./application"

import DisposalSelectorController from "./disposal_selector_controller"
application.register("disposal-selector", DisposalSelectorController)

import PreviousPickingDataController from "./previous_picking_data_controller"
application.register("previous_picking_data", PreviousPickingDataController)

import DisposalTypeController from "./disposal_type"
application.register("disposal-type", DisposalTypeController)

import DsaAwesomplete from "./dsa_awesomplete.js"
application.register("dsa-awesomplete", DsaAwesomplete)

import { DmTest, TurboModalController } from "dm_unibo_common"
application.register("turbo-modal", TurboModalController)


