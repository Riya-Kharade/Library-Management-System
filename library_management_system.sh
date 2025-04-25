#!/bin/bash

# Define file paths for storing data
DATA_FILE="library_data.txt"
ISSUED_FILE="issued_books.txt"
STUDENTS_FILE="students.txt"

# Function to display admin menu
admin_menu() {
    echo -e "\n************ Admin Menu ************"
    echo "1. Insert a book"
    echo "2. Update a book"
    echo "3. Delete a book"
    echo "4. Search for a book by ID"
    echo "5. Display all books"
    echo "6. Display all books in order (A-Z)"
    echo "7. Issue a book"
    echo "8. Logout"
    echo "*"
}

# Function to display student menu
student_menu() {
    echo -e "\n*********** Student Menu ***********"
    echo "a. Enter student details"
    echo "b. Display available books"
    echo "c. Search for a book"
    echo "d. Display books issued to you"
    echo "f. Logout"
    echo "*"
}

# Function to insert a book
insert_book() {
    echo "******** Insert a new book ********"
    echo -n "Enter Book ID: "; read book_id
    echo -n "Enter Book Name: "; read book_name
    echo -n "Enter Author Name: "; read author_name
    echo -n "Enter Publisher: "; read publisher
    echo -n "Enter Publisher Year: "; read publisher_year
    echo -n "Enter Number of Copies: "; read copies

    if grep -q "^$book_id:" "$DATA_FILE"; then
        echo "Book with the same ID already exists..."
    else
        echo "$book_id:$book_name:$author_name:$publisher:$publisher_year:$copies" >> "$DATA_FILE"
        echo "Book inserted successfully..."
    fi
}

# Function to update a book by ID
update_book() {
    echo -n "Enter Book ID to Update: "; read book_id
    if grep -q "^$book_id:" "$DATA_FILE"; then
        echo "Enter updated book information:"
        echo -n "Book Name (Enter to keep current): "; read new_book_name
        echo -n "Author Name (Enter to keep current): "; read new_author_name
        echo -n "Publisher (Enter to keep current): "; read new_publisher
        echo -n "Publisher Year (Enter to keep current): "; read new_publisher_year
        echo -n "Copies (Enter to keep current): "; read new_copies

        existing_entry=$(grep "^$book_id:" "$DATA_FILE")
        current_book_name=$(echo "$existing_entry" | cut -d ':' -f 2)
        current_author_name=$(echo "$existing_entry" | cut -d ':' -f 3)
        current_publisher=$(echo "$existing_entry" | cut -d ':' -f 4)
        current_publisher_year=$(echo "$existing_entry" | cut -d ':' -f 5)
        current_copies=$(echo "$existing_entry" | cut -d ':' -f 6)

        updated_entry="$book_id:${new_book_name:-$current_book_name}:${new_author_name:-$current_author_name}:${new_publisher:-$current_publisher}:${new_publisher_year:-$current_publisher_year}:${new_copies:-$current_copies}"

        sed -i "s/^$book_id:.*/$updated_entry/" "$DATA_FILE"
        echo "Book updated successfully."
    else
        echo "Book with ID $book_id not found."
    fi
}

# Function to delete a book by ID
delete_book() {
    echo -n "Enter Book ID to Delete: "; read book_id
    if grep -q "^$book_id:" "$DATA_FILE"; then
        sed -i "/^$book_id:/d" "$DATA_FILE"
        echo "Book with ID $book_id deleted successfully."
    else
        echo "Book with ID $book_id not found."
    fi
}

# Function to search for a book by ID
search_book() {
    echo -n "Enter Book ID to Search: "; read book_id
    if grep -q "^$book_id:" "$DATA_FILE"; then
        grep "^$book_id:" "$DATA_FILE"
    else
        echo "Book with ID $book_id not found."
    fi
}

# Function to display all books (same for admin and student)
display_all_books() {
    echo "List of all books in tabular format:"
    echo "------------------------------------------------------------------------------------------------------------------------"
    printf "| %-6s | %-30s | %-20s | %-20s | %-6s | %-6s |\n" "ID" "Book Name" "Author Name" "Publisher" "Year" "Copies"
    echo "------------------------------------------------------------------------------------------------------------------------"
    while IFS=: read -r book_id book_name author_name publisher publisher_year copies; 
    do
        printf "| %-6s | %-30s | %-20s | %-20s | %-6s | %-6s |\n" "$book_id" "$book_name" "$author_name" "$publisher" "$publisher_year" "$copies"
    done < "$DATA_FILE"
    echo "------------------------------------------------------------------------------------------------------------------------"
}

# Function to display books in order (A-Z) for Admin
display_books_in_order() {
    echo "Books in A-Z Order:"
    echo "------------------------------------------------------------------------------------------------------------------------"
    printf "| %-6s | %-30s | %-20s | %-20s | %-6s | %-6s |\n" "ID" "Book Name" "Author Name" "Publisher" "Year" "Copies"
    echo "------------------------------------------------------------------------------------------------------------------------"
    sort -t ':' -k 2 "$DATA_FILE" | while IFS=: read -r book_id book_name author_name publisher publisher_year copies
    do
        printf "| %-6s | %-30s | %-20s | %-20s | %-6s | %-6s |\n" "$book_id" "$book_name" "$author_name" "$publisher" "$publisher_year" "$copies"
    done
    echo "------------------------------------------------------------------------------------------------------------------------"
}

# Function for issuing a book
issue_book() {
    echo -n "Enter Student Roll Number: "; read roll_no
    # Check if student exists
    if ! grep -q "^$roll_no:" "$STUDENTS_FILE"; then
        echo "Student with Roll Number $roll_no not found."
        return
    fi

    echo -n "Enter Book ID to issue: "; read book_id

    if grep -q "^$book_id:" "$DATA_FILE"; then
        current_copies=$(grep "^$book_id:" "$DATA_FILE" | cut -d ':' -f 6)
        if [ "$current_copies" -gt 0 ]; then
            new_copies=$((current_copies - 1))
            awk -F ':' -v id="$book_id" -v nc="$new_copies" 'BEGIN {OFS=":"} $1==id {$6=nc} {print}' "$DATA_FILE" > temp && mv temp "$DATA_FILE"
            echo "$roll_no:$book_id" >> "$ISSUED_FILE"
            echo "Book with ID $book_id issued successfully to Roll No: $roll_no."
        else
            echo "No available copies for Book ID $book_id."
        fi
    else
        echo "Book with ID $book_id not found."
    fi
}

# Function for student to enter details
enter_student_details() {
    echo -n "Enter Student Roll Number: "; read roll_no
    echo -n "Enter Student Name: "; read name
    echo "$roll_no:$name" >> "$STUDENTS_FILE"
    echo "Student details saved."
}

# Function for student to display available books (same as admin)
display_books() {
    display_all_books
}

# Function for student to search books
search_books() {
    echo "Search by:"
    echo "1. Author Name"
    echo "2. Title"
    echo "3. Publisher"
    echo -n "Enter choice: "; read ch
    echo -n "Enter search term: "; read term
    term_lower=$(echo "$term" | tr '[:upper:]' '[:lower:]')
    case $ch in
        1) awk -F ':' '{if (tolower($3) ~ /'"$term_lower"'/) print $0}' "$DATA_FILE";;
        2) awk -F ':' '{if (tolower($2) ~ /'"$term_lower"'/) print $0}' "$DATA_FILE";;
        3) awk -F ':' '{if (tolower($4) ~ /'"$term_lower"'/) print $0}' "$DATA_FILE";;
        *) echo "Invalid choice";;
    esac
}

# Function to show books issued to the student
show_my_books() {
    echo -n "Enter your Roll Number: "; read roll_no
    issued_books=$(grep "^$roll_no:" "$ISSUED_FILE")
    if [ -z "$issued_books" ]; then
        echo "No books issued to Roll No: $roll_no."
    else
        echo "Books issued to Roll No: $roll_no"
        echo "------------------------------------------------------------------------------------------------------------------------"
        printf "| %-6s | %-30s | %-20s | %-20s | %-6s | %-6s |\n" "ID" "Book Name" "Author Name" "Publisher" "Year" "Copies"
        echo "------------------------------------------------------------------------------------------------------------------------"
        echo "$issued_books" | while IFS=: read -r rn bid; do
            grep "^$bid:" "$DATA_FILE" | while IFS=: read -r id name author pub year copy; do
                printf "| %-6s | %-30s | %-20s | %-20s | %-6s | %-6s |\n" "$id" "$name" "$author" "$pub" "$year" "$copy"
            done
        done
        echo "------------------------------------------------------------------------------------------------------------------------"
    fi
}

# Main loop
clear
while true; do
    echo "********* Welcome to Library System *********"
    echo "Login as:"
    echo "1. Admin"
    echo "2. Student"
    echo "3. Exit"
    echo -n "Enter your choice: "; read choice

    case $choice in
        1)  # Admin login
            while true; do
                admin_menu
                echo -n "Enter choice: "; read admin_choice
                case $admin_choice in
                    1) insert_book ;;
                    2) update_book ;;
                    3) delete_book ;;
                    4) search_book ;;
                    5) display_all_books ;;
                    6) display_books_in_order ;;
                    7) issue_book ;;
                    8) break ;;
                    *) echo "Invalid choice" ;;
                esac
            done
            ;;
        2)  # Student login
            while true; do
                student_menu
                echo -n "Enter choice: "; read student_choice
                case $student_choice in
                    a) enter_student_details ;;
                    b) display_books ;;
                    c) search_books ;;
                    d) show_my_books ;;
                    f) break ;;
                    *) echo "Invalid choice" ;;
                esac
            done
            ;;
        3) exit 0 ;;
        *) echo "Invalid choice" ;;
    esac
done