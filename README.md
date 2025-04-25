# Library-Management-System
📚 A simple Library Management System created using Bash scripting to manage books in a library.📄 Features include adding, updating, deleting, searching, issuing, and displaying books.
<hr>

Here’s a **powerful and well-organized README** that combines both your Bash script files (`library.sh` and `library_management_system.sh`) into one unified and professional format. I’ve added **sections** for clarity, **highlighted all features** (including admin and student login), and kept your tone and purpose intact:

---

# 📚 Library Management System (Bash Script)

A simple and interactive Library Management System built using **Bash scripting**. This system is designed to automate the management of a library’s book collection, supporting both **Admin** and **Student** logins, making it easy to manage books, track users, and maintain records — all through the Linux terminal.

---

## 🌿 Project Overview

This project eliminates manual efforts in maintaining library records. It’s lightweight, terminal-based, and best suited for small libraries, college projects, or personal use.

---

## 🔐 User Roles

### 👨‍💼 Admin Login
Admin has full control over the system and can perform all book-related operations.

**Admin Menu Options:**
- Insert a book 📘  
- Update a book ✏️  
- Delete a book ❌  
- Search a book by ID 🔍  
- Display all books 📚  
- Display books alphabetically (A-Z) 🔠  
- Issue a book to a student 🎯  
- Logout 🔐  

---

### 👩‍🎓 Student Login
Students can view and search available books, and track issued books.

**Student Menu Options:**
- Enter student details 🧾  
- Display available books 📚  
- Search for a book 🔍  
- View issued books 📦  
- Logout 🔐  

---

## 🌎 Features

| Feature            | Description                                                                 |
|--------------------|-----------------------------------------------------------------------------|
| **Insert Book**     | Add books with ID, Title, Author, Publisher, Year, and Copies.              |
| **Update Book**     | Modify book details or update the number of copies.                         |
| **Delete Book**     | Remove books that are no longer available.                                  |
| **Search Book by ID** | Quickly locate a book using its unique ID.                               |
| **Display All Books**| View all book entries in a neat table format.                             |
| **Sort Books A-Z**  | Alphabetically arrange books by title.                                      |
| **Issue Book**      | Issue a book to a student and reduce the available count.                   |
| **Track Issued Books** | Students can see books they've been issued.                            |
| **Student Details** | Maintain a record of student information.                                   |

---

## 🔧 Technologies Used

- **Bash Scripting** – Core of the system  
- **Linux Terminal** – Runs directly in the shell, no external dependencies  
- **Text Files** – Used to store book and student data  

---

## 🎯 Purpose

This system helps:
- Automate tedious manual work in libraries  
- Reduce human errors in tracking issued books  
- Make book management easier for librarians and students  
- Serve as a practical project for learning shell scripting

---

## 📝 How to Run

### ✅ Prerequisites
- A Linux-based OS (Ubuntu, CentOS, etc.)
- Bash installed (default in most Linux systems)
- Terminal access

### 🚀 Steps to Run
```bash
# 1. Clone the Repository
git clone https://github.com/riya-kharade/library-management-system.git

# 2. Go to Project Directory
cd library-management-system

# 3. Make Script Executable
chmod +x library_management_system.sh

# 4. Run the Script
./library_management_system.sh
```

### 🧭 Interaction Flow

- On launching the script, select either **Admin** or **Student** login.
- Use the interactive menu to access features.
- Data is stored locally as `.txt` files for simplicity and portability.

---

## 💾 Data Handling

- Book and student data is stored using text files in the same directory.
- All operations update the file automatically.
- No external database required.

---

## 🗂 File Structure
```
📁 library-management-system/
├── library.sh                   # Earlier script version
├── library_management_system.sh # Final working script
├── books.txt                    # Book data file
├── students.txt                 # Student records
└── README.md                    # Project documentation
```

---

## 📩 Contact

If you have suggestions or questions, feel free to reach out:

- 📧 Email: riyasunilkharade.vit@gmail.com  
- 🔗 GitHub: [riya-kharade](https://github.com/riya-kharade)

---

Let me know if you'd like a **badge section** or **GIF demo**, I can help you add that too! Want me to convert this into a `.md` file directly?
📩 <b>Contact Information</b>
If you have any questions or feedback, feel free to reach out via the Email or connect with me through GitHub.

📧 Email: riyasunilkharade.vit@gmail.com

🔗 GitHub: https://github.com/riya-kharade
