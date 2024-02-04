import nodemailer from "nodemailer"
import dotenv from "dotenv"

dotenv.config()

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "inetsupersocial@gmail.com",
    pass: process.env.AUTH_PASSWORD,
  },
})

export default transporter
