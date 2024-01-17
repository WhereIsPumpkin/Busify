import User from "../models/User.js";

export const createUser = async (req, res) => {
    const { name, lastName, email, password, gender } = req.body;
    console.log(name)
    try {
        const newUser = new User({ name, lastName, email, password, gender });
        await newUser.save();

        return res.status(201).json(newUser);
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};
