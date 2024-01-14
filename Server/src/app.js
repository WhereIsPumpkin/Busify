import express from "express"
import connect from "./database/mongo.js"
import dotenv from "dotenv"
import { getUser } from "./controller/project-controller.js"

dotenv.config()
connect()

const app = express()

app.get("/", (req,res) => {
    return res.status(200).json({ message: "app works!" })
})

app.get("/api/user", getUser)

app.listen(3000);