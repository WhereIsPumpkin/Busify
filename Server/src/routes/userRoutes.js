import express from "express"
import {
  createUser,
  verifyUser,
  loginUser,
} from "../controller/user-controller.js"

const router = express.Router()

router.post("/login", loginUser)
router.post("/register", createUser)

router.post("/verify", verifyUser)


export default router
