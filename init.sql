-- Table: Member
CREATE TABLE "Member" (
    mem_id SERIAL PRIMARY KEY,
    mem_name VARCHAR(255) NOT NULL,
    mem_phone VARCHAR(50) NOT NULL,
    mem_email VARCHAR(255) UNIQUE NOT NULL,
    mem_password VARCHAR(255) NOT NULL
);

-- Table: Membership
CREATE TABLE "Membership" (
    membership_id SERIAL PRIMARY KEY,
    member_id INT NOT NULL,
    status VARCHAR(50) NOT NULL,
    FOREIGN KEY (member_id) REFERENCES "Member"(mem_id) ON DELETE CASCADE
);

-- Table: Collection
CREATE TABLE "Collection" (
    collection_id SERIAL PRIMARY KEY,
    collection_name VARCHAR(255) NOT NULL
);

-- Table: Category
CREATE TABLE "Category" (
    cat_id SERIAL PRIMARY KEY,
    cat_name VARCHAR(255) NOT NULL,
    sub_cat_name VARCHAR(255) NOT NULL
);

-- Table: Book
CREATE TABLE "Book" (
    book_id SERIAL PRIMARY KEY,
    book_name VARCHAR(255) NOT NULL,
    book_cat_id INT NOT NULL,
    book_collection_id INT NOT NULL,
    book_launch_date TIMESTAMP NOT NULL,
    book_publisher VARCHAR(255) NOT NULL,
    FOREIGN KEY (book_collection_id) REFERENCES "Collection"(collection_id) ON DELETE CASCADE,
    FOREIGN KEY (book_cat_id) REFERENCES "Category"(cat_id) ON DELETE CASCADE
);

-- Table: Issuance
CREATE TABLE "Issuance" (
    issuance_id SERIAL PRIMARY KEY,
    book_id INT NOT NULL,
    issuance_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    issuance_member INT NOT NULL,
    issued_by VARCHAR(255) NOT NULL,
    target_return_date TIMESTAMP DEFAULT (CURRENT_TIMESTAMP + INTERVAL '7 days'),
    issuance_status VARCHAR(50) NOT NULL,
    FOREIGN KEY (book_id) REFERENCES "Book"(book_id) ON DELETE CASCADE,
    FOREIGN KEY (issuance_member) REFERENCES "Member"(mem_id) ON DELETE CASCADE
);
