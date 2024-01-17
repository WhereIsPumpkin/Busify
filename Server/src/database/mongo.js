import mongoose from "mongoose";

const connectToMongoDB = async () => {
    const url = process.env.MONGO_URL;

    try {
        await mongoose.connect(url);
    } catch (error) {
        throw error;
    }
};

export default connectToMongoDB;
