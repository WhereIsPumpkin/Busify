import User from "../models/User.js";

export const getUser = async (req, res ) => {
    const data = await User.find()

    return res.status(200).json(data);
};