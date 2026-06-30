SELECT current_database();
//-----------------------------------------------------------
// HANDS-ON 5
// MongoDB - CRUD & Aggregation
//-----------------------------------------------------------

-----------------------------------------------------------
// Task 1 : Create Database & Collection
-----------------------------------------------------------

// 60. Create database

use college_nosql

// 61 & 62. Create collection and insert documents

db.feedback.insertMany([
{
    student_id:1,
    course_code:"CS101",
    semester:"2022-ODD",
    rating:5,
    comments:"Excellent teaching.",
    tags:["challenging","well-structured","good-examples"],
    submitted_at:new Date(),
    attachments:[{filename:"notes.pdf",size_kb:240}]
},
{
    student_id:2,
    course_code:"CS101",
    semester:"2022-ODD",
    rating:4,
    comments:"Very useful course.",
    tags:["challenging","interesting"],
    submitted_at:new Date(),
    attachments:[{filename:"assignment.pdf",size_kb:180}]
},
{
    student_id:3,
    course_code:"CS101",
    semester:"2022-EVEN",
    rating:3,
    comments:"Good.",
    tags:["practical"],
    submitted_at:new Date(),
    attachments:[{filename:"lab.pdf",size_kb:120}]
},
{
    student_id:4,
    course_code:"CS102",
    semester:"2022-ODD",
    rating:5,
    comments:"Loved the database labs.",
    tags:["sql","easy"],
    submitted_at:new Date(),
    attachments:[{filename:"db.pdf",size_kb:220}]
},
{
    student_id:5,
    course_code:"CS102",
    semester:"2022-ODD",
    rating:2,
    comments:"Need more practice.",
    tags:["sql","difficult"],
    submitted_at:new Date(),
    attachments:[{filename:"practice.pdf",size_kb:140}]
},
{
    student_id:6,
    course_code:"EC101",
    semester:"2021-EVEN",
    rating:3,
    comments:"Average.",
    tags:["circuits"],
    submitted_at:new Date(),
    attachments:[{filename:"notes.pdf",size_kb:90}]
},
{
    student_id:7,
    course_code:"ME101",
    semester:"2022-ODD",
    rating:4,
    comments:"Interesting concepts.",
    tags:["mechanics"],
    submitted_at:new Date(),
    attachments:[{filename:"me.pdf",size_kb:160}]
},
{
    student_id:8,
    course_code:"CS103",
    semester:"2022-ODD",
    rating:5,
    comments:"Excellent examples.",
    tags:["oop","java"],
    submitted_at:new Date(),
    attachments:[{filename:"oop.pdf",size_kb:200}]
},
{
    student_id:9,
    course_code:"CS103",
    semester:"2021-EVEN",
    rating:1,
    comments:"Very difficult.",
    tags:["hard"],
    submitted_at:new Date(),
    attachments:[{filename:"report.pdf",size_kb:130}]
},
{
    student_id:10,
    course_code:"CS102",
    semester:"2022-ODD",
    rating:4,
    comments:"Good explanation.",
    tags:["sql","queries"],
    submitted_at:new Date()
}
])

// 63.
// Last document intentionally has no attachments field.

// 64. Verify count

db.feedback.countDocuments()

-----------------------------------------------------------
// Task 2 : CRUD Operations
-----------------------------------------------------------

// 65. Rating = 5

db.feedback.find({rating:5})

-----------------------------------------------------------

// 66. CS101 with tag "challenging"

db.feedback.find({course_code:"CS101",tags:"challenging"})

-----------------------------------------------------------

// 67. Projection

db.feedback.find(
{},
{student_id:1,course_code:1,rating:1,_id:0}
)

-----------------------------------------------------------

// 68. Add needs_review

db.feedback.updateMany(
{rating:{$lt:3}},
{$set:{needs_review:true}}
)

-----------------------------------------------------------

// 69. Add reviewed tag

db.feedback.updateMany(
{needs_review:true},
{$push:{tags:"reviewed"}}
)

-----------------------------------------------------------

// 70. Delete 2021-EVEN feedback

db.feedback.deleteMany(
{semester:"2021-EVEN"}
)

-----------------------------------------------------------
// Task 3 : Aggregation Pipeline
-----------------------------------------------------------

// 71 & 72. Average rating and feedback count

db.feedback.aggregate([
{$match:{semester:"2022-ODD"}},
{$group:{
    _id:"$course_code",
    avg_rating:{$avg:"$rating"},
    total_feedback:{$sum:1}
}},
{$project:{
    _id:0,
    course_code:"$_id",
    average_rating:{$round:["$avg_rating",1]},
    total_feedback:1
}},
{$sort:{average_rating:-1}}
])

-----------------------------------------------------------

// 73. Tag frequency

db.feedback.aggregate([
{$unwind:"$tags"},
{$group:{
    _id:"$tags",
    count:{$sum:1}
}},
{$sort:{count:-1}}
])

-----------------------------------------------------------

// 74. Create index

db.feedback.createIndex(
{course_code:1}
)

// Verify index

db.feedback.find(
{course_code:"CS101"}
).explain("executionStats")

// Look for:
// "stage" : "IXSCAN"
// If it shows COLLSCAN, the index is not being used.