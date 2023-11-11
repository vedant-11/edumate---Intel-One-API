const facultyModel = require("../model/FacultySchema");

const createFaculty = async (req, res) => {
  const { _id, facultyName, subjectName, section, fn, email } = req.body;
  try {
    const facultyDetails = await facultyModel.create({
      _id,
      facultyName,
      subjectName,
      fn,
      section,
      email,
    });

    res.status(200).json({ facultyDetails });
  } catch (error) {
    res.json({ message: error.message });
  }
};

const getFaculty = async (req, res) => {
  try {
    const facultyDetails = await facultyModel.find();
    res.status(200).json({ facultyDetails });
  } catch (error) {
    res.json({ message: error.message });
  }
};

const getFacultyByfn = async (req, res) => {
  const { fn } = req.params;
  try {
    const facultyDetails = await facultyModel.find({ fn: fn });
    res.status(200).json({ facultyDetails });
  } catch (error) {
    res.json({ message: error.message });
  }
};

module.exports = { createFaculty, getFaculty, getFacultyByfn };
