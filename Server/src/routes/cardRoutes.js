import express from "express"
import {
  addCard,
  deleteCard
} from "../controller/card-controller.js"
import { authMiddleware } from "../middlewares/authMiddleware.js"

const router = express.Router()

router.post('/add', authMiddleware, addCard);

router.delete("/delete", authMiddleware, deleteCard)

export default router;