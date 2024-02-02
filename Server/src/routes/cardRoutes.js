import express from "express"
import {
  addCard
} from "../controller/card-controller.js"
import { authMiddleware } from "../middlewares/authMiddleware.js"

const router = express.Router()

router.post('/add-card', authMiddleware, addCard);

export default router;