import { application } from "./application"

import DisposalTypeController from "./disposal_type_controller"
application.register("disposal-type", DisposalTypeController)

import DisposalLabController from "./disposal_lab_controller"
application.register("disposal-lab", DisposalLabController)

import Accordion from "./accordion"
application.register("accordion", Accordion)

import LegalizeController from "./legalize_controller"
application.register("legalize", LegalizeController)

import PickingController from "./picking_controller.js"
application.register("picking", PickingController)

import DsaAwesomplete from "./dsa_awesomplete.js"
application.register("dsa-awesomplete", DsaAwesomplete)

import showhideController from "./showhide_controller.js"
application.register("showhide", showhideController)

import { DmTest, TurboModalController, LimitVisibleController } from "dm_unibo_common"
application.register("turbo-modal", TurboModalController)
application.register("limit-visible", LimitVisibleController)

