import express from "express"
import {
  createUser,
  verifyUser,
  loginUser,
  getUserInfo
} from "../controller/user-controller.js"
import { authMiddleware } from "../middlewares/authMiddleware.js"

const router = express.Router()

router.post("/login", loginUser)
router.post("/register", createUser)

router.post("/verify", verifyUser)

router.get("/info", authMiddleware, getUserInfo)

export default router
