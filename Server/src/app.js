import express from "express"
import connectToMongoDB from "./database/mongo.js"
import dotenv from "dotenv"
import { createUser } from "./controller/user-controller.js"
import bodyParser from "body-parser";

dotenv.config()
connectToMongoDB()

const app = express()

app.use(bodyParser.json());
app.use(express.json());

app.get("/", (req,res) => {
    return res.status(200).json({ message: "app works!" })
})

app.post("/api/user/register", createUser)

connectToMongoDB().then(() => {
    app.listen(3000, () => {
        console.log("Server is listening on port 3000");
    });
});