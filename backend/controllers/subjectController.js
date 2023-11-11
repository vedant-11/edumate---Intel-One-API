const subjectModel = require("../model/SubjectSchema");
const studentModel = require("../model/Schema");
const axios = require("axios");
const createSubject = async (req, res) => {
  const { subjectName, student, faculty } = req.body;
  try {
    const subjectDetails = await subjectModel.create({
      subjectName,
      student,
      faculty,
    });

    res.status(200).json({ subjectDetails });
  } catch (error) {
    res.json({ message: error.message });
  }
};

const getStudentByReg = async (reg) => {
  const studentDetails = await axios.get(
    "http://localhost:5000/student/" + reg
  );
  return studentDetails.data;
};

const MarkPresent = async (req, res) => {
  const { subjectName, student, faculty, classHappened } = req.body;
  try {
    const subjectDetails = await subjectModel.find({
      subjectName: subjectName,
      student: student,
      faculty: faculty,
    });
    if (subjectDetails) {
      const updatedAttendance = subjectModel.findOneAndUpdate(
        {
          subjectName: subjectName,
          student: student,
          // faculty: faculty,
        },
        { classHappened: classHappened }
      );
      res.status(200).json({ updatedAttendance });
    }
  } catch (error) {
    res.json({ message: error.message });
  }
};

const getStudentWithSameSubAndFaculty = async (req, res) => {
  const { subjectName, faculty } = req.params;
  try {
    const studentDetails = await subjectModel.find({
      subjectName: subjectName,
      faculty: faculty,
    });

    res.status(200).json(studentDetails);
  } catch (error) {
    res.json({ message: error.message });
  }
};

module.exports = {
  createSubject,
  MarkPresent,
  getStudentWithSameSubAndFaculty,
};
