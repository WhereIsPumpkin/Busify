import express from "express"
import { buyTicket, verifyTicket } from "../controller/ticket-controller.js"
import { authMiddleware } from "../middlewares/authMiddleware.js"

const router = express.Router()

router.post("/buy", authMiddleware, buyTicket)

router.get("/verify/:ticketId", verifyTicket)

export default router
