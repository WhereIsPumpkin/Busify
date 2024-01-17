import express from "express"
import connect from "./database/mongo.js"
import dotenv from "dotenv"
import { createUser } from "./controller/user-controller.js"
import bodyParser from "body-parser";

dotenv.config()
connect()

const app = express()

app.use(bodyParser.json());
app.use(express.json());

app.get("/", (req,res) => {
    return res.status(200).json({ message: "app works!" })
})

app.post("/api/user/register", createUser)

app.listen(3000);