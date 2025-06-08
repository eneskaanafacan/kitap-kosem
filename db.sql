-- Kitap Değerlendirme Sistemi Veritabanı Şeması

-- Kullanıcılar tablosu
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Kitaplar tablosu
CREATE TABLE books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Yorumlar tablosu
CREATE TABLE comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    user_id INT NOT NULL,
    comment TEXT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- İndeksler (performans için)
CREATE INDEX idx_comments_book_id ON comments(book_id);
CREATE INDEX idx_comments_user_id ON comments(user_id);
CREATE INDEX idx_books_title ON books(title);
CREATE INDEX idx_books_author ON books(author);

-- Örnek veriler (opsiyonel)
INSERT INTO users (username, password) VALUES 
('admin', SHA2('admin123', 256)),
('testuser', SHA2('test123', 256));

INSERT INTO books (title, author, description) VALUES 
('Suç ve Ceza', 'Fyodor Dostoyevski', 'Rus edebiyatının başyapıtlarından biri olan bu roman, genç Raskolnikov\'un psikolojik çelişkilerini anlatır.'),
('1984', 'George Orwell', 'Distopik bir gelecekte geçen bu roman, totaliter rejimin bireyler üzerindeki etkisini anlatır.'),
('Beyaz Geceler', 'Fyodor Dostoyevski', 'Petersburg\'da geçen romantik bir hikaye.');

INSERT INTO comments (book_id, user_id, comment, rating) VALUES 
(1, 1, 'Muhteşem bir eser! Dostoyevski\'nin psikoloji analizi harika.', 5),
(1, 2, 'Ağır ama değerli bir roman. Tavsiye ederim.', 4),
(2, 1, 'Günümüzde daha da anlamlı hale gelen bir kitap.', 5),
(3, 2, 'Kısa ama etkili bir hikaye.', 4);