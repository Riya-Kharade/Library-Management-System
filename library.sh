#!/bin/bash

# Define file paths for storing data
DATA_FILE="library_data.txt"

# Function to display menu
display_menu() {
    echo "Library Management System"
    echo "1. Insert a book"
    echo "2. Update a book"
    echo "3. Delete a book"
    echo "4. Search for a book by ID"
    echo "5. Display all books"
    echo "6. Display all books in order (A-Z)"
    echo "7. Issue a book"
    echo "8. Quit"
}

# Function to insert a book
insert_book() {
    echo "Insert a new book Details...."
    echo -n "Book ID: "
    read book_id
    echo -n "Book Name: "
    read book_name
    echo -n "Author Name: "
    read author_name
    echo -n "Publisher: "
    read publisher
    echo -n "Publisher Year: "
    read publisher_year
    echo -n "Copies: "
    read copies

    # Check if the book ID already exists
    if grep -q "^$book_id:" "$DATA_FILE"; then
        echo "Book with the same ID already exists..."
    else
        echo "$book_id:$book_name:$author_name:$publisher:$publisher_year:$copies" >> "$DATA_FILE"
        echo "Book inserted successfully..."
    fi
}

# Function to update a book by ID
update_book() {
    echo "Update a book by ID:"
    echo -n "Enter Book ID to Update: "
    read book_id

    if grep -q "^$book_id:" "$DATA_FILE"; then
        echo "Enter updated book information:"
        echo -n "Book Name (Enter to keep current value): "
        read new_book_name
        echo -n "Author Name (Enter to keep current value): "
        read new_author_name
        echo -n "Publisher (Enter to keep current value): "
        read new_publisher
        echo -n "Publisher Year (Enter to keep current value): "
        read new_publisher_year
        echo -n "Copies (Enter to keep current value): "
        read new_copies

        # Read the existing book entry
        existing_entry=$(grep "^$book_id:" "$DATA_FILE")

        # Extract the existing field values
        current_book_name=$(echo "$existing_entry" | cut -d ':' -f 2)
        current_author_name=$(echo "$existing_entry" | cut -d ':' -f 3)
        current_publisher=$(echo "$existing_entry" | cut -d ':' -f 4)
        current_publisher_year=$(echo "$existing_entry" | cut -d ':' -f 5)
        current_copies=$(echo "$existing_entry" | cut -d ':' -f 6)

        # Update fields with new values or keep the current value if no input is provided
        updated_entry="$book_id:${new_book_name:-$current_book_name}:${new_author_name:-$current_author_name}:${new_publisher:-$current_publisher}:${new_publisher_year:-$current_publisher_year}:${new_copies:-$current_copies}"

        # Update the book entry
        sed -i "s/^$book_id:.*/$updated_entry/" "$DATA_FILE"
        echo "Book updated successfully."
    else
        echo "Book with ID $book_id not found."
    fi
}

# Function to delete a book by ID
delete_book() {
    echo "Delete a book by ID:"
    echo -n "Enter Book ID to delete: "
    read book_id

    if grep -q "^$book_id:" "$DATA_FILE"; then
        sed -i "/^$book_id:/d" "$DATA_FILE"
        echo "Book deleted successfully."
    else
        echo "Book with ID $book_id not found."
    fi
}

# Function to search for a book by ID
search_book() {
    echo "Search for a book by ID:"
    echo -n "Enter Book ID to search: "
    read book_id

    if grep -q "^$book_id:" "$DATA_FILE"; then
        grep "^$book_id:" "$DATA_FILE"
    else
        echo "Book with ID $book_id not found."
    fi
}

# Function to display all books in tabular format
display_all_books() {
    echo "List of all books in tabular format:"
    echo "---------------------------------------------------------------"
    printf "| %-6s | %-30s | %-20s | %-20s | %-6s | %-6s |\n" "ID" "Book Name" "Author Name" "Publisher" "Year" "Copies"
    echo "---------------------------------------------------------------"
    while IFS=: read -r book_id book_name author_name publisher publisher_year copies; do
        printf "| %-6s | %-30s | %-20s | %-20s | %-6s | %-6s |\n" "$book_id" "$book_name" "$author_name" "$publisher" "$publisher_year" "$copies"
    done < "$DATA_FILE"
    echo "---------------------------------------------------------------"
}

# Function to display all books in order (A-Z)
display_books_in_order() {
    echo "List of books in alphabetical order:"
    echo "---------------------------------------------------------------"
    printf "| %-6s | %-30s | %-20s | %-20s | %-6s | %-6s |\n" "ID" "Book Name" "Author Name" "Publisher" "Year" "Copies"
    echo "---------------------------------------------------------------"
    sort -t ':' -k 2,2 "$DATA_FILE" | while IFS=: read -r book_id book_name author_name publisher publisher_year copies; do
        printf "| %-6s | %-30s | %-20s | %-20s | %-6s | %-6s |\n" "$book_id" "$book_name" "$author_name" "$publisher" "$publisher_year" "$copies"
    done
    echo "---------------------------------------------------------------"
}

# Function to issue a book
issue_book() {
    echo "Issue a book by ID:"
    echo -n "Enter Book ID to issue: "
    read book_id

    if grep -q "^$book_id:" "$DATA_FILE"; then
        current_copies=$(grep "^$book_id:" "$DATA_FILE" | cut -d ':' -f 6)
        if [ "$current_copies" -gt 0 ]; then
            sed -i "s/^$book_id:\(.\):\(.\):\(.\):\(.\):\(.*\)/$book_id:\1:\2:\3:\4:$((current_copies - 1))/" "$DATA_FILE"
            echo "Book with ID $book_id issued successfully."
        else
            echo "No available copies of the book with ID $book_id."
        fi
    else
        echo "Book with ID $book_id not found."
    fi
}

# Main loop
while true; do
    display_menu
    echo -n "Enter your choice: "
    read choice

    case $choice in
        1) insert_book ;;
        2) update_book ;;
         3) delete_book ;;
        4) search_book ;;
        5) display_all_books ;;
        6) display_books_in_order ;;
        7) issue_book ;;
        8) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
done