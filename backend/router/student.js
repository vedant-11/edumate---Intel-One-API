const express = require("express");
const router = express.Router();
const {
  getAllStudents,
  getStudentByName,
  createStudent,
  getDeviceName,
} = require("../controllers/studentControllers");

router.get("/", getAllStudents);
router.get("/:reg", getStudentByName);
router.post("/", createStudent);
router.get("/:reg/:device", getDeviceName);
module.exports = router;
