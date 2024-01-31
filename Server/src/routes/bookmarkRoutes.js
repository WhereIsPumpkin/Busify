import express from "express"
import {
  addBookmark,
  removeBookmark,
} from "../controller/bookmark-controller.js"
import { authMiddleware } from "../middlewares/authMiddleware.js"

const router = express.Router()

router.post("/bookmark/add", authMiddleware, addBookmark)
router.post("/bookmark/remove", authMiddleware, removeBookmark)

export default router
