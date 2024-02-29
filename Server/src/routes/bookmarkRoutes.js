import express from "express"
import { toggleBookmark } from "../controller/bookmark-controller.js"
import { authMiddleware } from "../middlewares/authMiddleware.js"

const router = express.Router()

router.post("/toggle", authMiddleware, toggleBookmark)

export default router
