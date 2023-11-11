const student = require("../model/Schema");

const getAllStudents = async (req, res) => {
  try {
    const students = await student.find();
    res.json(students);
  } catch (error) {
    res.json({ message: error.message });
  }
};

const getStudentByName = async (req, res) => {
  try {
    const students = await student.find({ reg: req.params.reg });
    res.json(students);
  } catch (error) {
    res.json({ message: error.message });
  }
};

const createStudent = async (req, res) => {
  const { _id, name, semester, email, phone, reg, section, points, device } =
    req.body;
  try {
    const studentDetails = await student.create({
      _id,
      name,
      semester,
      email,
      phone,
      section,
      points,
      device,
      reg,
    });

    res.status(200).json({ studentDetails });
  } catch (error) {
    res.json({ message: error.message });
  }
};

//i have my api baseURL/api/:reg/:device how to find the student that have that device

const getDeviceName = async (req, res) => {
  try {
    const reg = req.params.reg;
    const device = req.params.device;

    // Find student by registration number and device
    const studentDevice = await student.findOne({
      reg: reg,
      device: device,
    });

    if (studentDevice) {
      res.status(200).json("Verified");
    } else {
      res.status(404).send("Wrong Device trying to access kindly check again");
    }
  } catch (error) {
    console.error("Error in getStudentByDevice:", error);
    res.status(500).send("Internal Server Error");
  }
};

module.exports = {
  getAllStudents,
  getStudentByName,
  createStudent,
  getDeviceName,
};
