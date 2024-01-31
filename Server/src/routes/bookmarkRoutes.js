import express from "express"
import {
  addBookmark,
  removeBookmark,
} from "../controller/bookmark-controller.js"

const router = express.Router()

router.post("/add", addBookmark)

router.post("/remove", removeBookmark)

export default router
