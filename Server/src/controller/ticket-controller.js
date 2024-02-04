import QRCode from "qrcode";
import nodemailer from "nodemailer";
import dotenv from "dotenv";
import BusTicket from "../models/BusTicket.js";

dotenv.config();

// Configure the transporter for nodemailer
let transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "inetsupersocial@gmail.com",
    pass: process.env.AUTH_PASSWORD,
  },
});

export const buyTicket = async (req, res) => {
  const userId = req.userData.id;
  const { cardName, price, duration } = req.body;

  try {
    const ticket = new BusTicket({
      cardName,
      price,
      duration,
      userId,
    });

    const savedTicket = await ticket.save();

    // Generate QR code as a buffer
    const qrCodeBuffer = await QRCode.toBuffer(`https://www.facebook.com/NRdental`);

    // Email options with QR code as an attachment
    let mailOptions = {
      from: "inetsupersocial@gmail.com",
      to: "sgogr2021@agruni.edu.ge", // Replace with recipient's email address
      subject: "Your Bus Ticket",
      html: `
        <div style="font-family: 'Arial', sans-serif; color: #333;">
          <h2>მადლობა შენაძენისთვის!</h2>
          <p>ძვირფასო მომხმარებელო,</p>
          <p>ბილეთის შეძენა, წარმატებით განხორციელდა. აქ არის თქვენი ტრანზაქციის დეტალები:</p>
          <ul>
            <li>ბილეთის ტიპი: <strong>${cardName}</strong></li>
            <li>ფასი: <strong>$${price.toFixed(2)}</strong></li>
            <li>მოქმედების ვადა: <strong>${duration}</strong></li>
          </ul>
          <p>თქვენი ბილეთი, მზადაა გამოსაყენებლად და იმოქმედებს მითითებული ვადით. ქვემოთ თან ერთვის თქვენი ავტობუსის ბილეთის QR კოდი. ავტობუსში ასვლისას, წარმოადგინეთ QR კოდი.</p>
          <img src="cid:qrcode" alt="Bus Ticket QR Code" style="margin-top: 20px; max-width: 200px;"/>
          <p>მადლობა, რომ ირჩევთ ჩვენს სერვისს. გისურვებთ ბედნიერ მგზავრობას!</p>
          <p><strong>Bussify Social Team</strong></p>
        </div>
      `,
      attachments: [{
        filename: 'qrcode.png',
        content: qrCodeBuffer,
        cid: 'qrcode'
      }]
    };

    await transporter.sendMail(mailOptions);

    res.status(201).json({
      message: "Ticket purchased successfully",
      ticket: savedTicket,
      qrCodeURL: 'QR code sent via email',
    });
  } catch (error) {
    console.error("Error in buyTicket:", error);
    res.status(500).json({ message: "Error purchasing ticket", error: error.message });
  }
};
