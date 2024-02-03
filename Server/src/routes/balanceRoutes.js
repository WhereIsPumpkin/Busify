import express from "express"
import {
  fillBalance,
} from "../controller/balance-controller.js"
import { authMiddleware } from "../middlewares/authMiddleware.js"

const router = express.Router()

router.post('/fill', authMiddleware, fillBalance);

export default router;