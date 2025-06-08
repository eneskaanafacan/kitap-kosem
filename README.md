# KitapKöşem: Online Kitap İnceleme ve Puanlama Sistemi

## Proje Hakkında
KitapKöşem, kullanıcıların kitaplar hakkında yorum yapabildiği ve puanlama yapabildiği bir web uygulamasıdır. Java Servlet ve JSP teknolojileri kullanılarak geliştirilmiştir.

## Gereksinimler
- Java JDK 8 veya üzeri
- Apache Tomcat 9.0 veya üzeri
- MySQL 8.0 veya üzeri
- Eclipse IDE (önerilen) veya herhangi bir Java IDE
- Web tarayıcısı (Chrome, Firefox, Safari)

## Kurulum Adımları

### 1. Veritabanı Kurulumu
1. MySQL'i başlatın
2. Yeni bir veritabanı oluşturun:
   ```sql
   CREATE DATABASE kitapkosem;
   USE kitapkosem;
   ```
3. Proje klasöründeki `db.sql` dosyasını çalıştırın:
   ```bash
   mysql -u root -p kitapkosem < db.sql
   ```

### 2. Veritabanı Bağlantı Ayarları
1. `src/databse/DatabaseConfig.java` dosyasını açın
2. Aşağıdaki ayarları kendi veritabanı bilgilerinize göre düzenleyin:
   ```java
   private static final String URL = "jdbc:mysql://localhost:XXXX/kitapkosem";
   private static final String USERNAME = "root";
   private static final String PASSWORD = "your_password";
   ```

### 3. Proje İçe Aktarma (Eclipse IDE)
1. Eclipse'i açın
2. File → Import → Existing Projects into Workspace
3. Proje klasörünü seçin
4. Import'a tıklayın

### 4. Kütüphane Ayarları
1. Proje üzerinde sağ tık → Properties
2. Java Build Path → Libraries
3. Add External JARs seçin
4. Aşağıdaki JAR dosyalarını ekleyin:
   - MySQL Connector (`mysql-connector-java-8.0.x.jar`)

### 5. Tomcat Sunucu Ayarları
1. Eclipse'te Servers sekmesini açın
2. New → Server → Apache Tomcat v10.1
3. Tomcat kurulum klasörünü belirtin
4. Projeyi sunucuya ekleyin

## Çalıştırma

### 1. Sunucuyu Başlatma
1. Eclipse'te Servers sekmesinden Tomcat sunucusunu seçin
2. Start butonuna tıklayın
3. Konsol çıktısında hata olmadığını kontrol edin

### 2. Uygulamaya Erişim
1. Web tarayıcınızı açın
2. Aşağıdaki URL'ye gidin:
   ```
   http://localhost:8080/KitapKosem/
   ```

## Kullanım

### İlk Giriş
1. Ana sayfada "Kayıt Ol" butonuna tıklayın
2. Kullanıcı adı ve şifre belirleyin
3. "Giriş Yap" ile sisteme giriş yapın


### Temel İşlemler
1. **Kitap Listeleme:** Ana sayfada tüm kitapları görüntüleyin
2. **Kitap Arama:** Arama çubuğunu kullanarak istediğiniz kitabı bulun
3. **Kitap Ekleme:** Giriş yaptıktan sonra "Kitap Ekle" menüsünü kullanın
4. **Yorum Yapma:** Kitap detay sayfasında yorum yazın ve puan verin


## Özellikler
- ✅ Kullanıcı kayıt ve giriş sistemi
- ✅ Kitap ekleme, listeleme ve arama
- ✅ Kitap detay sayfaları
- ✅ Yorum ve puanlama sistemi
- ✅ Ortalama puan hesaplama
- ✅ Güvenli şifre saklama (SHA-256)

## Teknolojiler
- **Backend:** Java Servlet, JSP
- **Frontend:** HTML5, CSS3,JavaScript
- **Veritabanı:** MySQL
- **Sunucu:** Apache Tomcat
