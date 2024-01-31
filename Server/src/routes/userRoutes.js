import express from "express"
import {
  createUser,
  verifyUser,
  loginUser,
} from "../controller/user-controller.js"

const router = express.Router()

router.post("/register", createUser)

router.post("/verify", verifyUser)

router.post("/login", loginUser)

export default router
