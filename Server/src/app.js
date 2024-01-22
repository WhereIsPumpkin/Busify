import express from "express"
import connectToMongoDB from "./database/mongo.js"
import dotenv from "dotenv"
import {
  createUser,
  verifyUser,
  loginUser,
  debateUser
} from "./controller/user-controller.js"
import bodyParser from "body-parser"

dotenv.config()
connectToMongoDB()

const app = express()

app.use(bodyParser.json())
app.use(express.json())

app.post("/api/user/register", createUser)

app.post("/api/user/verify", verifyUser)

app.post("/api/user/login", loginUser)

app.post("/api/assistant/debate", debateUser);

connectToMongoDB().then(() => {
  app.listen(3000, () => {
    console.log("Server is listening on port 3000")
  })
})
