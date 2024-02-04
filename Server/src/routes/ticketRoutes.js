import express from "express"
import { buyTicket } from "../controller/ticket-controller.js"
import { authMiddleware } from "../middlewares/authMiddleware.js"

const router = express.Router()

router.post("/buy", authMiddleware, buyTicket)

export default router